# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SpecificationCodeForTaxSubstitution, type: :model do
  describe 'validations' do
    describe '#code' do
      it_behaves_like 'a basic presence requirement for', :specification_code_for_tax_substitution, :code
      it_behaves_like(
        'uniqueness requirement',
        :specification_code_for_tax_substitution,
        :code, -> { Faker::Number.number(digits: 8) }
      )
    end

    describe '#description' do
      it_behaves_like 'a basic presence requirement for', :specification_code_for_tax_substitution, :description
    end
  end
end
