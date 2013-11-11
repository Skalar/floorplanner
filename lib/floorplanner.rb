require "floorplanner/version"

require "active_support/all"
require "active_model"
require "pathname"
require "httpi"
require "nokogiri"
require "nori"

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



  # :nodoc:
  #
  # Read default config from file, just makes it easy for me to spin up
  # a console, read API credentials and get going
  def self.conf!
    read_default_configuration_from_file 'default_config.yml'
  end

  # :nodoc:
  def self.read_default_configuration_from_file(pathname)
    path = Pathname.new pathname
    path = Pathname.new [Dir.pwd, pathname].join('/') unless path.absolute?
    self.default_configuration = Configuration.new YAML.load_file(path)
  end
end
