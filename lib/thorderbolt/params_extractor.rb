# frozen_string_literal: true

module Thorderbolt
  class ParamsExtractor
    # Recursively search through the hash to find the last elements:
    # 1. The name of the table we want to condition on
    # 2. The attribute name
    # 3. The attribute values for ordering by.
    # @param hash [Hash] the ActiveRecord-style arguments, such as:
    #   { other_objects: { id: [1, 5, 3] } }
    # @param table [String/Symbol] the name of the table
    def self.extract(hash, table_name)
      raise StandardError, 'Could not parse params' unless hash.size == 1

      key, value = hash.first

      return extract(hash[key], key) if value.is_a? Hash

      {
        table: table_name,
        attribute: key,
        values: value
      }
    end
  end
end
