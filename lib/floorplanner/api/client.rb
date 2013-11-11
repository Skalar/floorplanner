module Floorplanner
  module Api
    module Client
      extend ActiveSupport::Concern

      included do
        class_attribute :_configuration, instance_writer: false
        delegate :configuration, to: :class
      end

      module ClassMethods
        def configuration=(config)
          self._configuration = config
        end

        def configuration
          _configuration or ::Floorplanner.default_configuration
        end


        private

        def build_request(options = {})
          HTTPI::Request.new(options).tap do |request|
            request.auth.basic configuration.api_key, configuration.api_password
          end
        end
      end

    end
  end
end
