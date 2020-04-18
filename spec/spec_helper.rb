# frozen_string_literal: true

require 'bundler/setup'
require 'thorderbolt'
require 'active_record'
require 'pry-byebug'

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'

current_dirname = File.dirname(__FILE__)
load "#{current_dirname}/dummy/db/schema.rb"
Dir.glob("#{current_dirname}/dummy/models/*.rb").sort.each { |r| require r }

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
