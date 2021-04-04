# frozen_string_literal: true

class GlobalProductClassification < ApplicationRecord
  has_many :products, inverse_of: :global_product_classification, dependent: :destroy

  validates :code, presence: true, uniqueness: { allow_blank: true }

  validates :description, presence: true
end
