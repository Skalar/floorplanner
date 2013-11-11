module Floorplanner
  module Api
    module UrlBuilder
      extend ActiveSupport::Concern

      module ClassMethods
        def endpoint_for_collection
          [endpoint, format].join '.'
        end

        def endpoint_for_single(id)
          [
            [endpoint, id].join('/'),
            format
          ].join '.'
        end

        def endpoint
          [base_url, resource_path].join('/')
        end

        private

        def resource_path
          resource_name.pluralize
        end

        def base_url
          [protocol, host].join '://'
        end

        def host
          [subdomain, domain].join '.'
        end

        def format
          'xml'
        end

        # Delegates protocol to configuration.api_protocol
        %w[protocol domain subdomain].each do |name|
          define_method name do
            configuration.public_send ['api', name].join('_')
          end
        end
      end


      delegate :endpoint, to: :class
    end
  end
end
