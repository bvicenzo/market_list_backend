# frozen_string_literal: true

class GlobalTradeItemNumber < ApplicationRecord
  validates :number, presence: true, uniqueness: { allow_blank: true }
  validates :type_packaging, presence: true
  validates :ballast, numericality: { allow_blank: true, only_integer: true, greater_than: 0 }
  validates :layer, numericality: { allow_blank: true, only_integer: true, greater_than: 0 }
  validates(
    :quantity_packaging,
    presence: true,
    numericality: { allow_blank: true, only_integer: true, greater_than: 0 }
  )
end
