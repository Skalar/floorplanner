module Floorplanner
  module Api
    module Client
      extend ActiveSupport::Concern

      module ClassMethods
        def all
          request = build_request url: endpoint_for_collection
          response = HTTPI.get request

          [request, response]
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
