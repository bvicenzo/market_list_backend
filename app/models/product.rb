# frozen_string_literal: true

class Product < ApplicationRecord
  attribute :raw_name, :raw_string

  has_many :global_trade_item_numbers, inverse_of: :product, dependent: :destroy

  belongs_to :brand, inverse_of: :products, optional: true
  belongs_to :global_product_classification, inverse_of: :products, optional: true
  belongs_to :mercosul_common_nomenclature, inverse_of: :products, optional: true
  belongs_to :specification_code_for_tax_substitution, inverse_of: :products, optional: true

  validates :name, :raw_name, presence: true

  before_validation :fill_raw_name

  private

  def fill_raw_name
    self.raw_name = name
  end
end
