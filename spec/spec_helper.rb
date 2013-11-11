require 'bundler/setup'
require 'floorplanner'

require 'webmock/rspec'

WebMock.disable_net_connect!

RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
end
