# frozen_string_literal: true

RSpec.describe Thorderbolt::ParamsExtractor do
  subject(:extracted) { described_class.call(extracting, table_name) }

  let(:table_name) { :users }

  context 'with plain extracting params' do
    let(:extracting) { { field_name: :some_value } }

    it 'takes initial table name' do
      expect(extracted).to eq(
        table_name: table_name,
        attribute: :field_name,
        values: :some_value
      )
    end
  end

  context 'with nested extracting params' do
    let(:extracting) { { joined_table_name: { field_name: :some_value } } }

    it 'takes the most deep data' do
      expect(extracted).to eq(
        table_name: :joined_table_name,
        attribute: :field_name,
        values: :some_value
      )
    end
  end

  context 'with nested deeper than one level' do
    let(:extracting) do
      { joined_firstly: { joined_secondly: { field_name: :some_value } } }
    end

    it 'takes the most deep data' do
      expect(extracted).to eq(
        table_name: :joined_secondly,
        attribute: :field_name,
        values: :some_value
      )
    end
  end

  context 'with wrong formatted params were passed' do
    let(:extracting) do
      { root: { one: { key: :value }, two: { key: :value } } }
    end

    it 'raises error' do
      expect { extracted }.to raise_error(Thorderbolt::ParamsParsingError)
    end
  end
end
