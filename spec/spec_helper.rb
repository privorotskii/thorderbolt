# frozen_string_literal: true

require 'bundler/setup'
require 'thorderbolt'
require 'active_record'
require 'factory_bot'
require 'pry-byebug'

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'

current_dirname = File.dirname(__FILE__)
%w[dummy initializers shared_examples].each do |dir_name|
  Dir.glob("#{current_dirname}/#{dir_name}/**/*.rb").sort.each { |f| require f }
end

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
