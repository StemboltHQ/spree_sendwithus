require 'simplecov'
SimpleCov.start do
  add_filter 'spec'
  add_filter 'vendor/bundle'
  add_group 'Libraries', 'lib'
end

RSpec.configure do |config|
  config.mock_with :rspec
  config.color = true

  config.fail_fast = ENV['FAIL_FAST'] || false
end
