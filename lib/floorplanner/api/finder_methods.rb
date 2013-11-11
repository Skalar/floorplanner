module Floorplanner
  module Api
    module FinderMethods
      extend ActiveSupport::Concern

      module ClassMethods
        def all
          request = build_request url: endpoint_for_collection
          response = HTTPI.get request

          parser = Nori.new
          parsed = parser.parse response.body
          instantiate_collection parsed[resource_name.pluralize]
        end

        def find(id)
          request = build_request url: endpoint_for_single(id)
          response = HTTPI.get request

          parser = Nori.new
          parsed = parser.parse response.body
          instantiate 'attributes' => parsed[resource_name]
        end


        private

        def instantiate(coder)
          new coder['attributes']
        end

        def instantiate_collection(collection)
          fail "TODO"
        end
      end
    end
  end
end
