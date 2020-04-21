# frozen_string_literal: true

module Thorderbolt
  # Recursively search through the hash to find the last elements:
  # 1. The name of the table we want to condition on
  # 2. The attribute name
  # 3. The attribute values for ordering by.
  class ParamsExtractor
    def self.call(hash, table_name)
      raise ParamsParsingError, 'Could not parse params' unless hash.size == 1

      key, value = hash.first
      return call(hash[key], key) if value.is_a? Hash

      {
        table_name: table_name,
        attribute: key,
        values: value
      }
    end
  end
end
