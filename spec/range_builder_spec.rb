# frozen_string_literal: true

RSpec.describe Thorderbolt::RangeBuilder do
  subject(:result) { described_class.build(:table, :col, range) }

  context 'with usual range' do
    let(:range) { (1..8) }

    it 'returns correct condition' do
      expect(result).to eq('"table"."col" >= 1 AND "table"."col" <= 8')
    end
  end

  context 'with reversed range' do
    let(:range) { (8..1) }

    it 'sorts range correctly' do
      expect(result).to eq('"table"."col" >= 1 AND "table"."col" <= 8')
    end
  end

  context 'with exclusive range' do
    let(:range) { (1...8) }

    it 'makes closing condition strict' do
      expect(result).to eq('"table"."col" >= 1 AND "table"."col" < 8')
    end
  end
end
