require "floorplanner/version"

require "active_support/all"

module Floorplanner
  extend ActiveSupport::Autoload

  autoload :Configuration
  autoload :Api


  # Public: Default configuration is read from here.
  #
  # You can, per api resource, set different configurations.
  # If none is set, it will read configfrom this object instead.
  #
  # Returns a Configuration object
  mattr_accessor :default_configuration
end
