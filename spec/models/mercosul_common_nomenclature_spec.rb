# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MercosulCommonNomenclature, type: :model do
  describe 'validations' do
    describe '#code' do
      it_behaves_like 'a basic presence requirement for', :mercosul_common_nomenclature, :code
      it_behaves_like(
        'uniqueness requirement',
        :mercosul_common_nomenclature,
        :code, -> { Faker::Number.number(digits: 8) }
      )
    end

    describe '#description' do
      it_behaves_like 'a basic presence requirement for', :mercosul_common_nomenclature, :code
    end
  end
end
