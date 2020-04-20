# frozen_string_literal: true

module Thorderbolt
  # Builds full query for performing custom ordering
  class OrderQueryBuilder < BaseQueryBuilder
    # result example:
    # CASE
    #   WHEN 'cities'.'name'='City 1' THEN 0
    #   WHEN 'cities'.'name'='City 5' THEN 1
    #   ELSE 2
    # END ASC

    protected

    # result example:
    # WHEN 'cities'.'name'='City 1' THEN 0
    def build_when_then_part(conditions)
      conditions.map.with_index do |condition, index|
        "WHEN #{condition} THEN #{index}"
      end
    end

    # result example:
    # CASE
    #   WHEN 'cities'.'name'='City 1' THEN 0
    #   WHEN 'cities'.'name'='City 5' THEN 1
    #   ELSE 2
    # END
    def build_case_else(when_queries)
      "CASE #{when_queries.join(' ')} ELSE #{when_queries.size} END"
    end
  end
end
