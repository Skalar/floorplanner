require 'bundler/setup'
require 'floorplanner'

require_relative 'helpers'

RSpec.configure do |c|
  c.include Helpers
end
