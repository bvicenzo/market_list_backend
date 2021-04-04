# frozen_string_literal: true

class Brand < ApplicationRecord
  attribute :raw_name, :raw_string

  has_many :products, inverse_of: :brand, dependent: :destroy

  validates :name, presence: true
  validates :raw_name, presence: true, uniqueness: { allow_blank: true }

  before_validation :fill_raw_name

  private

  def fill_raw_name
    self.raw_name = name
  end
end
