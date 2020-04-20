# frozen_string_literal: true

require 'thorderbolt/version'
require 'thorderbolt/exceptions'
require 'thorderbolt/range_builder'
require 'thorderbolt/params_extractor'
require 'thorderbolt/base_query_builder'
require 'thorderbolt/order_query_builder'
require 'thorderbolt/order_any_query_builder'

# Active Record customer ordering
module Thorderbolt
  def order_as(hash)
    order_with_builder(hash, OrderQueryBuilder)
  end

  def order_as_any(hash)
    order_with_builder(hash, OrderAnyQueryBuilder)
  end

  protected

  def order_with_builder(hash, builder)
    params = ParamsExtractor.call(hash, table_name)
    values = params[:values]

    return all if params[:values].empty?
    raise ThorderboltError, 'Cannot order by `nil`' if values.any?(&:nil?)

    builder = builder.new(params)
    order(Arel.sql(builder.build))
  end
end
