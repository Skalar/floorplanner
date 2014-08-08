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

      def export(id, width:, height:, callback: nil, send_to: nil, type: nil,
                paper_scale: nil, scaling: nil, scalebar: nil, black_white: nil)

        raise ArgumentError, "width: cannot be nil" if width.nil?
        raise ArgumentError, "height: cannot be nil" if height.nil?

        if (callback.nil? && send_to.nil?) || (callback && send_to)
          raise ArgumentError, "Either callback: or send_to: must be given as a keyword argument."
        end

        content = {
          resolution: {
            width: width,
            height: height            
          }
        }

        add_if_present(content, :callback, callback)
        add_if_present(content, "send-to", send_to)
        add_if_present(content, :type, type)
        add_if_present(content, "paper-scale", paper_scale)
        add_if_present(content, :scaling, scaling)
        add_if_present(content, :scalebar, scalebar)
        add_if_present(content, "black-white", black_white)

        xml = Gyoku.xml({export: {:@xmlns => "http://floorplanner.com/export/request", :content! => content}})
        client.post("projects/#{id}/render", xml)
      end

      private

      def add_if_present(hash, key, value)
        hash[key] = value unless value.nil?
      end
    end
  end
end
