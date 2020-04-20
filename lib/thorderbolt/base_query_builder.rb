# frozen_string_literal: true

module Thorderbolt
  # Builds full query for performing custom ordering
  class BaseQueryBuilder
    attr_reader :table_name, :attribute, :values

    def initialize(table_name:, attribute:, values:)
      @table_name = table_name
      @attribute = attribute
      @values = values
    end

    # result example:
    # CASE
    #   WHEN 'cities'.'name'='City 1' THEN 0
    #   WHEN 'cities'.'name'='City 5' THEN 1
    #   ELSE 2
    # END ASC
    def build
      conditions = build_conditions
      when_queries = build_when_then_part(conditions)
      case_query = build_case_else(when_queries)
      Arel.sql("#{case_query} ASC")
    end

    protected

    def build_conditions
      values.map do |value|
        value.is_a?(Range) ? range_equality_part(value) : equality_part(value)
      end
    end

    # result example:
    # 'cities'.'name'
    def equality_part(value)
      connection = ActiveRecord::Base.connection
      full_column_name = "#{connection.quote_table_name(table_name)}"\
                          ".#{connection.quote_column_name(attribute)}"

      ActiveRecord::Base.sanitize_sql(
        ["#{full_column_name} = :value", value: value]
      )
    end

    # result example:
    # 'cities'.'population' >= 100 AND 'cities'.'population' < 200
    def range_equality_part(value)
      RangeBuilder.build(table_name, attribute, value)
    end
  end
end
