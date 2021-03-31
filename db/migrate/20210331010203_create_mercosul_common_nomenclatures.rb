# frozen_string_literal: true

class CreateMercosulCommonNomenclatures < ActiveRecord::Migration[6.1]
  def change
    create_table :mercosul_common_nomenclatures, id: :uuid do |t|
      t.string :code, null: false, index: { unique: true }
      t.string :description, null: false
      t.string :full_description

      t.timestamps
    end
  end
end
