# frozen_string_literal: true

RSpec.shared_examples 'a positive integer number requirement' do |model_name, attribute_name|
  describe 'on create' do
    subject(:model) { build(model_name, attributes) }

    let(:attributes) { { attribute_name => attribute_value } }

    before { model.valid? }

    context "when #{attribute_name} is not sent" do
      let(:attribute_value) { nil }

      it 'does not validate numeric presence' do
        expect(model.errors.details[attribute_name]).to_not include(a_hash_including(error: :not_a_number))
      end
    end

    context "when #{attribute_name} is sent" do
      context 'but it is not a number' do
        let(:attribute_value) { 'a text' }

        it 'requires it to be a number' do
          expect(model.errors.details[attribute_name]).to include(error: :not_a_number, value: attribute_value)
        end
      end

      context 'and it is a number' do
        context 'but it is not an integer' do
          let(:attribute_value) { 2.35 }

          it 'requires it to be an integer' do
            expect(model.errors.details[attribute_name])
              .to include(error: :not_an_integer, value: attribute_value)
          end
        end

        context 'and it is an integer' do
          context 'but the number is negative' do
            let(:attribute_value) { -1 }

            it 'requires it to be a positive integer' do
              expect(model.errors.details[attribute_name])
                .to include(error: :greater_than, count: 0, value: attribute_value)
            end
          end

          context 'and the number is zero' do
            let(:attribute_value) { 0 }

            it 'requires it to be a positive integer' do
              expect(model.errors.details[attribute_name])
                .to include(error: :greater_than, count: 0, value: attribute_value)
            end
          end

          context 'and the number greater than zero' do
            let(:attribute_value) { 1 }

            it 'accepts the number' do
              expect(model.errors.details[attribute_name])
                .to_not include(a_hash_including(error: :greater_than))
            end
          end
        end
      end
    end
  end

  describe 'on update' do
    subject(:model) { create(model_name) }

    context 'when no value is changed' do
      before { model.valid? }

      it 'keeps it valid' do
        expect(model.errors.details[attribute_name]).to be_empty
      end
    end

    context "when #{attribute_name} is changed" do
      let(:attributes) { { attribute_name => attribute_value } }

      before do
        model.attributes = attributes
        model.valid?
      end

      context "and #{attribute_name} erased" do
        let(:attribute_value) { nil }

        it 'does not validate numeric presence' do
          expect(model.errors.details[attribute_name]).to_not include(a_hash_including(error: :not_a_number))
        end
      end

      context "and #{attribute_name} is changed" do
        context 'but it is not a number' do
          let(:attribute_value) { 'a text' }

          it 'requires it to be a number' do
            expect(model.errors.details[attribute_name]).to include(error: :not_a_number, value: attribute_value)
          end
        end

        context 'and it is a number' do
          context 'but it is not an integer' do
            let(:attribute_value) { 2.35 }

            it 'requires it to be an integer' do
              expect(model.errors.details[attribute_name])
                .to include(error: :not_an_integer, value: attribute_value)
            end
          end

          context 'and it is an integer' do
            context 'but the number is negative' do
              let(:attribute_value) { -1 }

              it 'requires it to be a positive integer' do
                expect(model.errors.details[attribute_name])
                  .to include(error: :greater_than, count: 0, value: attribute_value)
              end
            end

            context 'and the number is zero' do
              let(:attribute_value) { 0 }

              it 'requires it to be a positive integer' do
                expect(model.errors.details[attribute_name])
                  .to include(error: :greater_than, count: 0, value: attribute_value)
              end
            end

            context 'and the number greater than zero' do
              let(:attribute_value) { 1 }

              it 'accepts the number' do
                expect(model.errors.details[attribute_name])
                  .to_not include(a_hash_including(error: :greater_than))
              end
            end
          end
        end
      end
    end
  end
end
