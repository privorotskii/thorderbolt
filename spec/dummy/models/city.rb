# frozen_string_literal: true

class City < ActiveRecord::Base
  extend Thorderbolt

  has_many :users
end
