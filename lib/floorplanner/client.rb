module Floorplanner
  class Client
    def initialize(api_key:, password:, subdomain:, protocol: "https")
      @api_key = api_key
      @password = password
      @subdomain = subdomain
      @protocol = protocol
    end

    # Returns an instance based
    # on values from the following
    # environment variables:
    #
    # FLOORPLANNER_API_KEY
    # FLOORPLANNER_PASSWORD
    # FLOORPLANNER_SUBDOMAIN
    #
    # The instance will use https.
    def self.from_env
      new(
        api_key: ENV["FLOORPLANNER_API_KEY"],
        password: ENV["FLOORPLANNER_PASSWORD"],
        subdomain: ENV["FLOORPLANNER_SUBDOMAIN"]
      )
    end

    def get(resource_path)
      res = HTTPI.get(build_request(resource_path))
      check_result(res)
    end

    def post(resource_path, xml)
      req = build_request(resource_path)
      req.body = xml
      req.headers["Content-Type"] = "text/xml"
      res = HTTPI.post(req)
      check_result(res)
    end

    private

    def check_result(res)
      if res.error?
        raise Error, "HTTP error #{res.code} - #{res.body}" 
      end

      res
    end

    def build_request(resource_path)
      req = HTTPI::Request.new(build_url(resource_path))
      req.auth.basic(@api_key, @password)
      req
    end

    def build_url(resource_path)
      "#{@protocol}://#{@subdomain}.floorplanner.com/#{resource_path}"
    end

    class Error < StandardError
    end
  end
end
