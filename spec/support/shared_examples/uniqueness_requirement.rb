# frozen_string_literal: true

RSpec.shared_examples 'uniqueness requirement' do |model_name, attribute_name, value_generator|
  describe 'on create' do
    subject(:model) { build(model_name, attributes) }

    let(:attributes) { { attribute_name => attribute_value } }

    before { model.valid? }

    context "when #{attribute_name} is not sent" do
      let(:attribute_value) { nil }

      it 'does not validates it' do
        expect(model.errors.details[attribute_name]).to_not include(error: :taken, value: attribute_value)
      end
    end

    context "when #{attribute_name} is sent" do
      context 'when there is already in other record' do
        let(:another_record) { create(model_name) }
        let(:attribute_value) { another_record.public_send(attribute_name) }

        it "requires #{attribute_name} to be unique" do
          expect(model.errors.details[attribute_name]).to include(error: :taken, value: attribute_value)
        end
      end

      context 'when is a new one' do
        let(:attribute_value) { value_generator.call }

        it "accepts the new #{attribute_name}" do
          expect(model.errors.details[attribute_name]).to_not include(error: :taken, value: attribute_value)
        end
      end
    end
  end

  describe 'on update' do
    subject(:model) { create(model_name) }

    let(:attributes) { { attribute_name => attribute_value } }

    before do
      model.attributes = attributes
      model.valid?
    end

    context "when #{attribute_name} is not sent" do
      let(:attribute_value) { nil }

      it 'does not validates it' do
        expect(model.errors.details[attribute_name]).to_not include(error: :taken, value: attribute_value)
      end
    end

    context "when #{attribute_name} is sent" do
      context 'when there is already in other record' do
        let(:another_record) { create(model_name) }
        let(:attribute_value) { another_record.public_send(attribute_name) }

        it "requires #{attribute_name} to be unique" do
          expect(model.errors.details[attribute_name]).to include(error: :taken, value: attribute_value)
        end
      end

      context 'when is a new one' do
        let(:attribute_value) { value_generator.call }

        it "accepts the new #{attribute_name}" do
          expect(model.errors.details[attribute_name]).to_not include(error: :taken, value: attribute_value)
        end
      end
    end
  end
end
