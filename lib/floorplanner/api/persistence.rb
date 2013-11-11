module Floorplanner
  module Api
    module Persistence
      extend ActiveSupport::Concern

      def save
        # TODO Not complete at all, just me testing *update* a loaded record from the API.
        # Need to consider if this is a new record or not, and we should also reload record
        # with data we get back from the API after an save.
        request = build_request url: endpoint_for_single(attributes['id'])
        request.headers['Content-Type'] = "application/xml"

        request.body = to_xml
        response = HTTPI.put request

        [request, response]
      end

      def destroy
        fail "TODO"
      end
    end
  end
end
