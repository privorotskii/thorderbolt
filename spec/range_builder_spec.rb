# frozen_string_literal: true

RSpec.describe Thorderbolt::RangeBuilder do
  subject { described_class.range_clause(:col, range) }

  context 'usual range' do
    let(:range) { (1..8) }

    it 'returns correct condition' do
      expect(subject).to eq("'col' >= 1 AND 'col' <= 8")
    end
  end

  context 'range is reversed' do
    let(:range) { (8..1) }

    it 'sorts range correctly' do
      expect(subject).to eq("'col' >= 1 AND 'col' <= 8")
    end
  end

  context 'range is exclusive' do
    let(:range) { (1...8) }

    it 'makes closing condition strict' do
      expect(subject).to eq("'col' >= 1 AND 'col' < 8")
    end
  end
end
