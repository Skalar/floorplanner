module Floorplanner
  class Client
    class Error < StandardError
    end

    def initialize(api_key, password, subdomain, protocol = "https")
      @api_key = api_key
      @password = password
      @subdomain = subdomain
      @protocol = protocol
    end

    def projects
      res = get("projects.xml")

      if res.error?
        raise Error, "HTTP error #{res.code} - #{res.body}" 
      end

      ::Floorplanner::Models::Projects.from_xml(res.body).projects
    end

    private

    def get(resource_path)
      HTTPI.get(build_request(resource_path))
    end

    def post(resource_path)
      raise "Not implemented"
    end

    def build_request(resource_path)
      req = HTTPI::Request.new(build_url(resource_path))
      req.auth.basic(@api_key, @password)
      req
    end

    def build_url(resource_path)
      "#{@protocol}://#{@subdomain}.floorplanner.com/#{resource_path}"
    end
  end
end
