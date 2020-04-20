# frozen_string_literal: true

module Thorderbolt
  # Builds full query for performing custom ordering
  class OrderAnyQueryBuilder < BaseQueryBuilder
    # result example:
    # CASE
    #   WHEN 'cities'.'name'='City 1' OR 'cities'.'name'='City 5'
    #   THEN 1
    #   ELSE 2
    # END ASC

    protected

    # result example:
    # WHEN 'cities'.'name'='City 1' OR 'cities'.'name'='City 2' THEN 0
    def build_when_then_part(conditions)
      "WHEN #{conditions.join(' OR ')} THEN 0"
    end

    # result example:
    # CASE
    #   WHEN 'cities'.'name'='City 1'
    #     OR 'cities'.'name'='City 5' THEN 0
    #   ELSE 1
    # END
    def build_case_else(when_queries)
      "CASE #{when_queries} ELSE 1 END"
    end
  end
end
