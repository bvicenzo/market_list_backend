# frozen_string_literal: true

class CreateBrands < ActiveRecord::Migration[6.1]
  def change
    create_table :brands, id: :uuid do |t|
      t.string :name, null: false
      t.string :raw_name, null: false, index: { unique: true }
      t.string :picture_url

      t.timestamps
    end
  end
end
