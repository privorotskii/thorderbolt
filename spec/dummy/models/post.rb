# frozen_string_literal: true

class Post < ActiveRecord::Base
  extend Thorderbolt

  belongs_to :user
end
