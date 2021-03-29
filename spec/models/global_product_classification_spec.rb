# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GlobalProductClassification, type: :model do
  describe 'validations' do
    describe '#code' do
      it_behaves_like 'a basic presence requirement for', :global_product_classification, :code
      it_behaves_like(
        'uniqueness requirement',
        :global_product_classification,
        :code, -> { Faker::Number.number(digits: 8) }
      )
    end

    describe '#description' do
      it_behaves_like 'a basic presence requirement for', :global_product_classification, :description
    end
  end
end
