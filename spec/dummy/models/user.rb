# frozen_string_literal: true

class User < ActiveRecord::Base
  extend Thorderbolt

  belongs_to :city

  has_many :posts
end
