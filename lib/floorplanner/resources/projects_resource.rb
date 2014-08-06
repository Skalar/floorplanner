module Floorplanner
  module Resources
    class ProjectsResource < Resource
      def all(user_id: nil)
        path = user_id.nil? ? "projects.xml" : "users/#{user_id}/projects.xml"
        res = client.get("projects.xml")
        ::Floorplanner::Models::ProjectsDocument.from_xml(res.body).projects
      end

      def find(id)
        res = client.get("projects/#{id}.xml")
        ::Floorplanner::Models::ProjectDocument.from_xml(res.body).project
      end

      def export(id, opts = {})
        xml = Gyoku.xml({export: {:@xmlns => "http://floorplanner.com/export/request", :content! => opts}})
        client.post("projects/#{id}/render", opts)
      end
    end
  end
end
