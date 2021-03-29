# frozen_string_literal: true

class CreateGlobalProductClassifications < ActiveRecord::Migration[6.1]
  def change
    create_table :global_product_classifications, id: :uuid do |t|
      t.string :code, null: false, index: { unique: true }
      t.text :description, null: false

      t.timestamps
    end
  end
end
