module Floorplanner
  module Resources
    class ProjectsResource < Resource
      def all
        res = client.get("projects.json")
        ::Floorplanner::Models::ProjectsDocument.from_json(res.body).projects
      end

      def find(id)
        res = client.get("projects/#{id}.json")
        ::Floorplanner::Models::ProjectDocument.from_json(res.body).project
      end

      def create(project)
        res = client.post("projects.json", project.to_json)
        ::Floorplanner::Models::ProjectDocument.from_json(res.body).project
      end

      def delete(id)
        client.delete("projects/#{id}.json")
      end

      def export(id)
        res = client.get("projects/#{id}.fml")
        res.body
      end

      def render_2d(id, callback:, width:, height:, orientation:, combine:, fmt: 'jpg')
        json = {
          callback: callback,
          width: width,
          height: height,
          fmt: [fmt],
          type: '2d',
          paper: {
            orientation: orientation,
            combine: combine
          }
        }.to_json

        client.post("projects/#{id}/export.json", json)
      end

      def render_3d(id, callback:, width:, height:, orientation:, view:, combine:, fmt: 'jpg')
        raise ArgumentError, "Unsupported view type: #{view}" unless %w{ se sw ne nw top }.include?(view)

        json = {
          callback: callback,
          width: width,
          height: height,
          fmt: [fmt],
          type: '3d',
          views: [
            {type: view}
          ],
          paper: {
            orientation: orientation,
            combine: combine
          }
        }.to_json

        client.post("projects/#{id}/export.json", json)
      end

      def publish(id)
        json = {public: true}.to_json
        res = client.put("projects/#{id}.json", json)
        ::Floorplanner::Models::ProjectDocument.from_json(res.body).project
      end

      def unpublish(id)
        json = {public: false}.to_json
        res = client.put("projects/#{id}.json", json)
        ::Floorplanner::Models::ProjectDocument.from_json(res.body).project
      end

      private

      def add_if_present(hash, key, value)
        hash[key] = value unless value.nil?
      end
    end
  end
end
