# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Brand, type: :model do
  describe 'validations' do
    describe '#name' do
      it_behaves_like 'a basic presence requirement for', :brand, :name
    end

    describe '#raw_name' do
      context 'on create' do
        subject(:brand) { build(:brand, attributes) }

        let(:attributes) { { name: name } }

        before { brand.valid? }

        context 'when name is not sent' do
          let(:name) { nil }

          it 'requires raw_name presence' do
            expect(brand.errors.details[:raw_name]).to include(error: :blank)
          end
        end

        context 'when name is sent' do
          let(:name) { 'Paçoquita' }

          it 'requires raw_name presence' do
            expect(brand.errors.details[:raw_name]).to_not include(error: :blank)
          end
        end
      end

      context 'on update' do
        subject(:brand) { create(:brand) }

        let(:attributes) { { name: name } }

        before do
          brand.attributes = attributes
          brand.valid?
        end

        context 'when name is not sent' do
          let(:name) { nil }

          it 'requires raw_name presence' do
            expect(brand.errors.details[:raw_name]).to include(error: :blank)
          end
        end

        context 'when name is sent' do
          let(:name) { 'Paçoquita' }

          it 'requires raw_name presence' do
            expect(brand.errors.details[:raw_name]).to_not include(error: :blank)
          end
        end
      end
    end
  end

  describe 'before validation' do
    describe '#raw_name' do
      context 'on create' do
        subject(:brand) { build(:brand, name: name) }

        let(:name) { '    Chá de     Caroção     ' }

        it 'generate a raw name in down case' do
          expect { brand.valid? }
            .to change(brand, :raw_name)
            .from(nil)
            .to('cha de carocao')
        end
      end

      context 'on update' do
        subject(:brand) { create(:brand, name: name) }

        before { brand.name = new_name }

        context 'when name has not been updated' do
          let(:name) { '    Chá de     Caroção     ' }
          let(:new_name) { name }

          it 'keeps the raw_name the same' do
            expect { brand.valid? }.to_not change(brand, :raw_name)
          end
        end

        context 'when name has been changed' do
          let(:name) { '    Chá de     Caroção     ' }

          context 'but the name has been deleted' do
            let(:new_name) { nil }

            it 'removes the raw_name also' do
              expect { brand.valid? }
                .to change(brand, :raw_name)
                .from('cha de carocao')
                .to(nil)
            end
          end

          context 'and new name is another one' do
            let(:new_name) { '    Nestlè   ' }

            it 'changes the raw name also' do
              expect { brand.valid? }
                .to change(brand, :raw_name)
                .from('cha de carocao')
                .to('nestle')
            end
          end
        end
      end
    end
  end
end
