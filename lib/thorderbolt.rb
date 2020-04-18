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

    # TODO: returning 'all' here means user will get an array
    # bun in other case, if params will be present, user will get a relation
    # return self ?
    return all if params[:values].empty?

    if params[:values].any?(&:nil?)
      raise ThorderboltError, 'Cannot order by `nil`'
    end

    builder = QueryBuilder.new(params)
    order(Arel.sql(builder.build))
  end
end
