module Floorplanner
  module Resources
    class UsersResource < Resource
      def token(id)
        res = client.get("users/#{id}/token")
        res.body
      end
    end
  end
end
