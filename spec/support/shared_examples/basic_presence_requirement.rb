# frozen_string_literal: true

RSpec.shared_examples 'a basic presence requirement for' do |model_name, attribute_name|
  describe 'on create' do
    subject(:model) { build(model_name, attributes) }

    let(:attributes) { { attribute_name => attribute_value } }

    before { model.valid? }

    context "when #{attribute_name} is not sent" do
      let(:attribute_value) { nil }

      it 'requires its presence' do
        expect(model.errors.details[attribute_name]).to include(error: :blank)
      end
    end

    context "when #{attribute_name} is sent" do
      let(:attribute_value) { anything }

      it 'accepts the value' do
        expect(model.errors.details[attribute_name]).to_not include(error: :blank)
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

    context "when #{attribute_name} is removed" do
      let(:attribute_value) { nil }

      it 'requires its presence' do
        expect(model.errors.details[attribute_name]).to include(error: :blank)
      end
    end

    context "when #{attribute_name} is changed" do
      let(:attribute_value) { anything }

      it 'includes that change' do
        expect(model.changes).to have_key(attribute_name)
      end

      it 'accepts the value' do
        expect(model.errors.details[attribute_name]).to_not include(error: :blank)
      end
    end
  end
end
