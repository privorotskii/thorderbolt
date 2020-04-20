# frozen_string_literal: true

RSpec.describe Thorderbolt::OrderQueryBuilder do
  let(:instance) { described_class.new(params) }
  let(:params) do
    {
      table_name: 'cities',
      attribute: 'population',
      values: [400, 401...500, '600']
    }
  end

  describe '.build' do
    subject { instance.build }

    let(:expected_result) do
      'CASE '\
       'WHEN "cities"."population" = 400 THEN 0 '\
       'WHEN "cities"."population" >= 401 '\
          'AND "cities"."population" < 500 THEN 1 '\
       'WHEN "cities"."population" = \'600\' THEN 2 '\
       'ELSE 3 '\
       'END ASC'
    end

    it { is_expected.to eq(expected_result) }
  end
end
