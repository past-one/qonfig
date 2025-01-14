# frozen_string_literal: true

require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
])

SimpleCov.start { add_filter 'spec' }

require 'bundler/setup'
require 'qonfig'
require 'pry'

require_relative 'support/spec_support'

RSpec.configure do |config|
  config.order = :random
  Kernel.srand config.seed
  config.expect_with(:rspec) { |c| c.syntax = :expect }
end
