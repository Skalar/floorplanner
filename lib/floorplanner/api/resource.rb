module Floorplanner
  module Api
    class Resource
      include Client

      class_attribute :_configuration, instance_writer: false

      def self.configuration=(config)
        self._configuration = config
      end

      def self.configuration
        _configuration or ::Floorplanner.default_configuration
      end

      def initialize(attributes = {})

      end
    end
  end
end
