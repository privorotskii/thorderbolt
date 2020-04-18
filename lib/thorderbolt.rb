# frozen_string_literal: true

require 'thorderbolt/version'
require 'thorderbolt/range_builder'
require 'thorderbolt/params_extractor'

# Active Record customer ordering
module Thorderbolt
  def order_as(hash)
    params = ParamsExtractor.extract(hash, table_name)
    # TODO: returning 'all' here means user will get an array
    # bun in other case, if params will be present, user will get a relation
    return all if params[:values].empty?
    raise 'Cannot order by `nil`' if params[:values].any?(&:nil?)

    conditions = params[:values].map do |value|
      if value.is_a? Range
        RangeBuilder.range_clause(
          ActiveRecord::Base.sanitize_sql(
            [
              ':table.:attribute',
              table: params[:table],
              attribute: params[:attribute]
            ]
          ),
          value
        )
      else
        ActiveRecord::Base.sanitize_sql(
          [
            ':table.:attribute=:value',
            table: params[:table],
            attribute: params[:attribute],
            value: value
          ]
        )
      end
    end

    when_queries = conditions.map.with_index do |cond, index|
      "WHEN #{cond} THEN #{index}"
    end
    case_query = "CASE #{when_queries.join(' ')} ELSE #{conditions.size} END"
    order(Arel.sql("#{case_query} ASC"))
  end
end
