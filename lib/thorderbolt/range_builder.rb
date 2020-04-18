# frozen_string_literal: true

module Thorderbolt
  # Builds a part of query for using a range as a sorting parameter
  class RangeBuilder
    class << self
      def build(table, column, range)
        full_column_name = "#{connection.quote_table_name(table)}"\
                           ".#{connection.quote_column_name(column)}"

        closing_condition = range.exclude_end? ? '<' : '<='

        template = "#{full_column_name} >= :minimal "\
                   "AND #{full_column_name} #{closing_condition} :maximum"

        range_bounds = [range.begin, range.end]
        range_hash = { minimal: range_bounds.min, maximum: range_bounds.max }

        ActiveRecord::Base.sanitize_sql([template, range_hash])
      end

      protected

      def connection
        ActiveRecord::Base.connection
      end
    end
  end
end
