# frozen_string_literal: true

module Thorderbolt
  ThorderboltError = Class.new(StandardError)
  ParamsParsingError = Class.new(ThorderboltError)
end
