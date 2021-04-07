# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductImporterService, type: :service do
  describe '#run' do
    subject(:service) { described_class.new(code: code) }

    let(:code) { '123456' }

    around { |example| travel_to Time.current, &example }

    context 'when data is not received from source' do
      context 'and this error is a connection error' do
        before { allow_get_request(to: 'https://api.cosmos.bluesoft.com.br/gtins/123456.json').to_timeout }

        it 'returns a retryable error' do
          expect(service.run).to eq({ success: false, retryable: true, retry_in: 1.hour })
        end
      end

      context 'and this error is a server error' do
        before { stub_get(to: 'https://api.cosmos.bluesoft.com.br/gtins/123456.json', response_status: 502) }

        it 'returns a retryable error' do
          expect(service.run).to eq({ success: false, retryable: true, retry_in: 1.hour })
        end
      end

      context 'and this error is a client error' do
        context 'and rate limit is exceeded' do
          before { stub_get(to: 'https://api.cosmos.bluesoft.com.br/gtins/123456.json', response_status: 429) }

          it 'returns a retryable error' do
            expect(service.run).to eq({ success: false, retryable: true, retry_in: 1.day })
          end
        end

        context 'and the product is not found' do
          before { stub_get(to: 'https://api.cosmos.bluesoft.com.br/gtins/123456.json', response_status: 404) }

          it 'returns a non retryable error' do
            expect(service.run).to eq({ success: false, retryable: false })
          end
        end
      end
    end

    context 'when some data is received from source' do
      before do
        stub_get(
          to: 'https://api.cosmos.bluesoft.com.br/gtins/123456.json',
          response_status: 200, response_body: product_data
        )
      end

      context 'and the product is a new one' do
        let(:product_data) { load_json_symbolized('bluesoft_products/broccoli.json') }

        context 'and product as no all associations' do
          it 'skips association importation' do
            expect { service.run }
              .to change(Product, :count).by(1)
              .and change(GlobalTradeItemNumber, :count).by(1)
              .and change(Brand, :count).by(0)
              .and change(GlobalProductClassification, :count).by(0)
              .and change(MercosulCommonNomenclature, :count).by(0)
              .and change(SpecificationCodeForTaxSubstitution, :count).by(0)
          end

          it 'imports product data', :aggregate_failures do
            importation = service.run
            product = importation[:product]
            expect(product.name).to eq(product_data[:description])
            expect(product.thumbnail).to eq(product_data[:thumbnail])
            expect(product.price).to eq(product_data[:price])
            expect(product.avg_price.to_f).to eq(product_data[:avg_price])
            expect(product.max_price.to_f).to eq(product_data[:max_price])
            expect(product.min_price.to_f).to eq(product_data[:min_price])
            expect(product.origin).to eq(product_data[:origin])
            expect(product.barcode_image).to eq(product_data[:barcode_image])

            global_trade_item_number = product.global_trade_item_numbers.first
            global_trade_item_number_data = product_data[:gtins].first

            expect(global_trade_item_number.number).to eq(global_trade_item_number_data[:gtin])
            commercial_unit_data = global_trade_item_number_data[:commercial_unit]
            expect(global_trade_item_number.type_packaging).to eq(commercial_unit_data[:type_packaging])
            expect(global_trade_item_number.quantity_packaging).to eq(commercial_unit_data[:quantity_packaging])
          end
        end

        context 'and product has all associations'
      end

      context 'and the product already exists on database'
    end
  end
end
