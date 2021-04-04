# frozen_string_literal: true

class MercosulCommonNomenclature < ApplicationRecord
  has_many :products, inverse_of: :mercosul_common_nomenclature, dependent: :destroy

  validates :code, presence: true, uniqueness: { allow_blank: true }
  validates :description, presence: true
end
