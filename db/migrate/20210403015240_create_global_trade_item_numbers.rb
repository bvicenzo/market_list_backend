# frozen_string_literal: true

class CreateGlobalTradeItemNumbers < ActiveRecord::Migration[6.1]
  def change
    create_table :global_trade_item_numbers, id: :uuid do |t|
      t.bigint :number, null: false, index: { unique: true }
      t.string :type_packaging, null: false
      t.integer :quantity_packaging, null: false
      t.integer :ballast
      t.integer :layer

      t.timestamps
    end
  end
end
