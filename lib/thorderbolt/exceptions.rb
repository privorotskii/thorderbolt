# frozen_string_literal: true

module Thorderbolt
  require 'pry-byebug'
  ThorderboltError = Class.new(StandardError)
  ParamsParsingError = Class.new(ThorderboltError)
end
