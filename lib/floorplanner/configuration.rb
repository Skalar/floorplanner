module Floorplanner
  class Configuration
    API_DEFAULTS = {
      api_password: 'x'
    }

    attr_accessor :api_key, :api_password, :api_subdomain

    def initialize(attributes = {})
      assign API_DEFAULTS
      assign attributes
    end

    def []=(name, value)
      public_send "#{name}=", value
    end

    def [](name)
      public_send name
    end



    private

    def assign(attributes)
      attributes.each_pair do |name, value|
        self[name] = value
      end
    end
  end
end
