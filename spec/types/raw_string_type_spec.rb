# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RawStringType, type: :type do
  describe '#cast' do
    subject(:raw_sting_type) { described_class.new }

    context 'when the value is nil' do
      it 'returns nil' do
        expect(raw_sting_type.cast(nil)).to be_nil
      end
    end

    context 'when the value is present' do
      context 'but the value is not a string' do
        it 'casts it to a string with no accents and no extra spaces' do
          expect(raw_sting_type.cast(:'Bananá   Speçial   ')).to eq('banana special')
        end
      end

      context 'and the value is a string' do
        it 'casts it to a string with no accents and no extra spaces' do
          expect(raw_sting_type.cast('   Paçoquitâ    Nestlé')).to eq('pacoquita nestle')
        end
      end
    end
  end
end
