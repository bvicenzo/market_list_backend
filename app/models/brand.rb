# frozen_string_literal: true

class Brand < ApplicationRecord
  has_many :products, inverse_of: :brand, dependent: :destroy

  validates :name, presence: true
  validates :raw_name, presence: true, uniqueness: { allow_blank: true }

  before_validation :build_raw_name

  private

  def build_raw_name
    self.raw_name = I18n.transliterate(name.to_s).downcase.squish.presence if new_record? || name_changed?
  end
end
