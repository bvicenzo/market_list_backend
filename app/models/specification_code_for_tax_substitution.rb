# frozen_string_literal: true

class SpecificationCodeForTaxSubstitution < ApplicationRecord
  has_many :products, inverse_of: :specification_code_for_tax_substitution, dependent: :destroy

  validates :code, presence: true, uniqueness: { allow_blank: true }
  validates :description, presence: true
end
