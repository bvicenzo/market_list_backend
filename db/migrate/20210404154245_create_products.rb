# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products, id: :uuid do |t|
      t.string :name, null: false
      t.string :raw_name, index: true
      t.string :thumbnail
      t.decimal :width
      t.decimal :height
      t.decimal :length
      t.decimal :net_weight
      t.decimal :gross_weight
      t.string :price
      t.decimal :avg_price, precision: 10, scale: 2
      t.decimal :max_price, precision: 10, scale: 2
      t.decimal :min_price, precision: 10, scale: 2
      t.string :origin
      t.string :barcode_image
      t.references :brand, type: :uuid, foreign_key: { on_delete: :cascade }
      t.references :global_product_classification, type: :uuid, foreign_key: { on_delete: :cascade }
      t.references :mercosul_common_nomenclature, type: :uuid, foreign_key: { on_delete: :cascade }
      t.references :specification_code_for_tax_substitution, type: :uuid, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
