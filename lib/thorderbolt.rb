# frozen_string_literal: true

require 'thorderbolt/version'
require 'thorderbolt/exceptions'
require 'thorderbolt/range_builder'
require 'thorderbolt/params_extractor'
require 'thorderbolt/query_builder'

# Active Record customer ordering
module Thorderbolt
  def order_as(hash)
    params = ParamsExtractor.call(hash, table_name)
    values = params[:values]

    return all if params[:values].empty?
    raise ThorderboltError, 'Cannot order by `nil`' if values.any?(&:nil?)

    builder = QueryBuilder.new(params)
    order(Arel.sql(builder.build))
  end
end
