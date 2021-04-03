# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GlobalTradeItemNumber, type: :model do
  describe 'validations' do
    describe '#number' do
      it_behaves_like(
        'a basic presence requirement for',
        :global_trade_item_number,
        :number, -> { Faker::Number.number(digits: 13) }
      )

      it_behaves_like(
        'uniqueness requirement',
        :global_trade_item_number,
        :number, -> { Faker::Number.number(digits: 13) }
      )
    end

    describe '#type_packaging' do
      it_behaves_like 'a basic presence requirement for', :global_trade_item_number, :type_packaging
    end

    describe '#quantity_packaging' do
      it_behaves_like(
        'a basic presence requirement for',
        :global_trade_item_number,
        :quantity_packaging,
        -> { Faker::Number.positive.to_i }
      )

      it_behaves_like 'a positive integer number requirement', :global_trade_item_number, :quantity_packaging
    end

    describe '#ballast' do
      it_behaves_like 'a positive integer number requirement', :global_trade_item_number, :ballast
    end

    describe '#layer' do
      it_behaves_like 'a positive integer number requirement', :global_trade_item_number, :layer
    end
  end
end
