# frozen_string_literal: true

class CreateSpecificationCodeForTaxSubstitutions < ActiveRecord::Migration[6.1]
  def change
    create_table :specification_code_for_tax_substitutions, id: :uuid do |t|
      t.string :code, null: false, index: { unique: true }
      t.string :description, null: false

      t.timestamps
    end
  end
end
