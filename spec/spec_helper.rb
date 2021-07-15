require 'vcr'
require "rspec"
require 'webmock/rspec'

require_relative '../utils/parsers'

# VCR.configure do |c|
#   c.cassette_library_dir = "spec/vcr_cassettes"
#   c.hook_into :webmock
# end

RSpec.configure do |config|
  config.before(:example) {  }
  config.mock_with :rspec
end