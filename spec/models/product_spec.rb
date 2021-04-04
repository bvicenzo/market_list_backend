# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'validations' do
    describe '#name' do
      it_behaves_like 'a basic presence requirement for', :product, :name
    end

    describe '#raw_name' do
      describe 'presence requirement' do
        describe 'on create' do
          subject(:product) { build(:product, attributes) }

          let(:attributes) { { name: name } }

          before { product.valid? }

          context 'when name is not sent' do
            let(:name) { nil }

            it 'requires raw_name presence' do
              expect(product.errors.details[:raw_name]).to include(error: :blank)
            end
          end

          context 'when name is sent' do
            let(:name) { 'Paçoquita' }

            it 'requires raw_name presence' do
              expect(product.errors.details[:raw_name]).to_not include(error: :blank)
            end
          end
        end

        describe 'on update' do
          subject(:product) { create(:product) }

          let(:attributes) { { name: name } }

          before do
            product.attributes = attributes
            product.valid?
          end

          context 'when name is not sent' do
            let(:name) { nil }

            it 'requires raw_name presence' do
              expect(product.errors.details[:raw_name]).to include(error: :blank)
            end
          end

          context 'when name is sent' do
            let(:name) { 'Paçoquita' }

            it 'requires raw_name presence' do
              expect(product.errors.details[:raw_name]).to_not include(error: :blank)
            end
          end
        end
      end
    end

    describe '#global_product_classification' do
      it_behaves_like(
        'a basic presence requirement for',
        :product,
        :global_product_classification,
        -> { FactoryBot.build(:global_product_classification) }
      )
    end

    describe '#mercosul_common_nomenclature' do
      it_behaves_like(
        'a basic presence requirement for',
        :product,
        :mercosul_common_nomenclature,
        -> { FactoryBot.build(:mercosul_common_nomenclature) }
      )
    end
  end
end
