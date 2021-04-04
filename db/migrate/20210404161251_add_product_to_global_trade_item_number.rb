# frozen_string_literal: true

class AddProductToGlobalTradeItemNumber < ActiveRecord::Migration[6.1]
  def change
    add_belongs_to(
      :global_trade_item_numbers,
      :product,
      type: :uuid,
      index: true,
      null: false,
      foreign_key: { on_delete: :cascade }
    )
  end
end
