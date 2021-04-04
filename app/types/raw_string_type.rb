# frozen_string_literal: true

class RawStringType < ActiveRecord::Type::String
  def cast(value)
    original_cast = super
    return if original_cast.nil?

    I18n.transliterate(original_cast).downcase.squish.presence
  end

  alias serialize cast
end
