# frozen_string_literal: true

class Brand < ApplicationRecord
  validates :name, :raw_name, presence: true

  before_validation :build_raw_name

  private

  def build_raw_name
    self.raw_name = I18n.transliterate(name.to_s).downcase.squish.presence if new_record? || name_changed?
  end
end
