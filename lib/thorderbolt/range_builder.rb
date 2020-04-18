# frozen_string_literal: true

module Thorderbolt
  class RangeBuilder
    class << self
      def range_clause(column, range)
        range_bounds = [range.first, range.last].sort

        closing_condition = range.exclude_end? ? '<' : '<='
        template = ":column >= :minimal AND :column #{closing_condition} :maximum"

        ActiveRecord::Base.sanitize_sql(
          [
            template,
            column: column,
            minimal: range_bounds.first,
            maximum: range_bounds.last
          ]
        )
      end

      # TODO: check for range creating for the column,
      # that exists in several joined tables simultaneously
      # That could lead to 'ambiguous column name' error
    end
  end
end
