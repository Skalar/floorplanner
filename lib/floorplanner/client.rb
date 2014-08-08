module Floorplanner
  class Client
    def initialize(api_key:, password:, subdomain:, protocol: "https")
      @api_key = api_key
      @password = password
      @subdomain = subdomain
      @protocol = protocol
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
