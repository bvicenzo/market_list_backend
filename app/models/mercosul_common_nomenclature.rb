# frozen_string_literal: true

class MercosulCommonNomenclature < ApplicationRecord
  validates :code, presence: true, uniqueness: { allow_blank: true }
  validates :description, presence: true
end
