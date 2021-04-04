# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Clients::BlueSoft::Cosmos::Product, type: :client do
  describe '#fetch_by_gtin' do
    subject(:client) { described_class.new }

    context 'when some timeout happens' do
      before { allow_get_request(to: 'https://api.cosmos.bluesoft.com.br/gtins/123456.json').to_timeout }

      it 'returns a unsuccessful return' do
        expect(client.fetch_by_gtin(code: '123456')).to eq(
          {
            success: false,
            error: {
              code: :network_error,
              message: 'execution expired'
            }
          }
        )
      end
    end

    context 'when there is a response' do
      context 'but is not a success response' do
        context 'and there is a server error' do
          before { stub_get(to: 'https://api.cosmos.bluesoft.com.br/gtins/123456.json', response_status: 502) }

          it 'returns a unsuccessful return' do
            expect(client.fetch_by_gtin(code: '123456')).to eq(
              {
                success: false,
                error: {
                  code: :server_error,
                  message: {}
                }
              }
            )
          end
        end

        context 'and there is a client error' do
          before do
            stub_get(
              to: 'https://api.cosmos.bluesoft.com.br/gtins/123456.json',
              response_status: 404,
              response_body: { message: 'O recurso solicitado não existe' }
            )
          end

          it 'returns a unsuccessful return' do
            expect(client.fetch_by_gtin(code: '123456')).to eq(
              {
                success: false,
                error: {
                  code: :client_error,
                  message: { message: 'O recurso solicitado não existe' }
                }
              }
            )
          end
        end
      end

      context 'and there is a sucessful response' do
        let(:product_data) { load_json_symbolized('bluesoft_products/black_tea.json') }

        before do
          stub_get(
            to: 'https://api.cosmos.bluesoft.com.br/gtins/123456.json',
            response_status: 200,
            response_body: product_data
          )
        end

        it 'returns a unsuccessful return' do
          expect(client.fetch_by_gtin(code: '123456')).to eq({ success: true, product_data: product_data })
        end
      end
    end
  end
end
