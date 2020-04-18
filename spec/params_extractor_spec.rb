# frozen_string_literal: true

RSpec.describe Thorderbolt::ParamsExtractor do
  subject { described_class.extract(extracting, table_name) }

  let(:table_name) { :users }

  context 'plain extracting params' do
    let(:extracting) { { field_name: :some_value } }

    it { is_expected.to eq(table: table_name, attribute: :field_name, values: :some_value) }
  end

  context 'nested extracting params' do
    let(:extracting) { { joined_table_name: { field_name: :some_value } } }

    it { is_expected.to eq(table: :joined_table_name, attribute: :field_name, values: :some_value) }
  end

  context 'nested deeper than one level' do
    let(:extracting) { { joined_firstly: { joined_secondly: { field_name: :some_value } } } }

    it { is_expected.to eq(table: :joined_secondly, attribute: :field_name, values: :some_value) }
  end
end
