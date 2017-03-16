module Floorplanner
  module Resources
    class ProjectsResource < Resource
      def all(user_id: nil)
        path = user_id.nil? ? "projects.xml" : "users/#{user_id}/projects.xml"
        res = client.get(path)
        ::Floorplanner::Models::ProjectsDocument.from_xml(res.body).projects
      end

      def find(id)
        res = client.get("projects/#{id}.xml")
        ::Floorplanner::Models::ProjectDocument.from_xml(res.body).project
      end

      def create(project, user_id: nil)
        url = user_id.nil? ? "projects.xml" : "users/#{user_id.to_i}/projects.xml"
        res = client.post(url, project.to_xml)
        ::Floorplanner::Models::ProjectDocument.from_xml(res.body).project
      end

      def overwrite(id, fml_xml:)
        res = client.put("projects/#{id}.xml", fml_xml)
        ::Floorplanner::Models::ProjectDocument.from_xml(res.body).project
      end

      def delete(id)
        client.delete("projects/#{id}.xml")
      end

      def create_floor(id, floor)
        client.post("projects/#{id}/floors.xml", floor.to_xml)
      end

      def add_collaborator(id, email:)
        xml = Gyoku.xml({email: email})
        client.post("projects/#{id}/collaborate.xml", xml)
      end

      def export(id)
        res = client.get("projects/#{id}/export.xml")
        res.body
      end

      def render(id, export)
        raise export.errors.first if export.errors.any?
        client.post("projects/#{id}/render", export.to_xml)
      end

      def render_2d(id, callback:, width:, height:, combine:, fmt: 'jpg')
        json = {
          callback: callback,
          width: width,
          height: height,
          combine: combine,
          fmt: fmt,
          type: '2d'
        }.to_json

        client.post("api/v2/projects/#{id}/export.json", json, content_type: "application/json")
      end

      def render_3d(id, callback:, width:, height:, section:, view:, combine:, fmt: 'jpg')
        raise ArgumentError, "Unsupported view type: #{view}" unless %w{ se sw ne nw top }.include?(view)

        json = {
          callback: callback,
          width: width,
          height: height,
          section: section,
          view: view,
          combine: combine,
          fmt: fmt
        }.to_json

        client.post("api/v2/projects/#{id}/export.json", json, content_type: "application/json")
      end

      def publish(id, project_configuration)
        raise project_configuration.errors.first if project_configuration.errors.any?
        res = client.post("projects/#{id}/configuration.xml", project_configuration.to_xml)
        ::Floorplanner::Models::PublishConfigurationDocument.from_xml(res.body).publish_configuration
      end

      def unpublish(id)
        res = client.delete("projects/#{id}/configuration.xml")
        ::Floorplanner::Models::ProjectDocument.from_xml(res.body).project
      end

      private

      def add_if_present(hash, key, value)
        hash[key] = value unless value.nil?
      end
    end
  end
end
