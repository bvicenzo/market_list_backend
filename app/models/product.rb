# frozen_string_literal: true

class Product < ApplicationRecord
  has_many :global_trade_item_numbers, inverse_of: :product, dependent: :destroy

  belongs_to :brand, inverse_of: :products
  belongs_to :global_product_classification, inverse_of: :products
  belongs_to :mercosul_common_nomenclature, inverse_of: :products
  belongs_to :specification_code_for_tax_substitution, inverse_of: :products, optional: true

  validates :name, :raw_name, presence: true

  before_validation :build_raw_name

  private

  def build_raw_name
    self.raw_name = I18n.transliterate(name.to_s).downcase.squish.presence if new_record? || name_changed?
  end
end
