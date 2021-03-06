module Floorplanner
  class Client
    def initialize(api_key:, password:, subdomain:, protocol: "https", api_path: "/api/v2")
      @api_key = api_key
      @password = password
      @subdomain = subdomain
      @protocol = protocol
      @api_path = api_path
    end

    def self.logger
      @logger ||= Logger.new(STDOUT).tap { |l| l.level = Logger::WARN }
    end

    def self.logger=(logger)
      @logger = logger
    end

    # Returns an instance based
    # on values from the following
    # environment variables:
    #
    # FLOORPLANNER_API_KEY
    # FLOORPLANNER_PASSWORD
    # FLOORPLANNER_SUBDOMAIN
    # FLOORPLANNER_PROTOCOL
    #
    # The instance will use https if
    # FLOORPLANNER_PROTOCOL is not set.
    def self.from_env
      new(
        api_key: ENV["FLOORPLANNER_API_KEY"],
        password: ENV["FLOORPLANNER_PASSWORD"],
        subdomain: ENV["FLOORPLANNER_SUBDOMAIN"],
        protocol: ENV.fetch("FLOORPLANNER_PROTOCOL", "https")
      )
    end

    def get(resource_path)
      logger.debug("GET to #{resource_path}")

      res = HTTPI.get(build_request(resource_path))
      check_result(res)
    end

    def post(resource_path, body, content_type: "application/json")
      logger.debug("POST to #{resource_path} as #{content_type}:\n\n#{body}")

      req = build_request(resource_path)
      req.body = body
      req.headers["Content-Type"] = content_type
      res = HTTPI.post(req)
      check_result(res)
    end

    def put(resource_path, body, content_type: "application/json")
      logger.debug("PUT to #{resource_path} as #{content_type}:\n\n#{body}")

      req = build_request(resource_path)
      req.body = body
      req.headers["Content-Type"] = content_type
      res = HTTPI.put(req)
      check_result(res)
    end

    def delete(resource_path)
      logger.debug("DELETE to #{resource_path}")

      res = HTTPI.delete(build_request(resource_path))
      check_result(res)
    end

    private

    def check_result(res)
      if res.error?
        if res.body.match("<errors>")
          result_hash = Nori.new.parse(res.body)
          error_messages = result_hash["errors"]["error"]
          error_messages = Array.try_convert(error_messages) || [error_messages]
          raise Error.new("HTTP error #{res.code} - #{error_messages.join(", ")}", res.body)
        else
          raise Error.new("HTTP error #{res.code}", res.body)
        end
      end

      res
    end

    def build_request(resource_path)
      req = HTTPI::Request.new(build_url(resource_path))
      req.auth.basic(@api_key, @password)
      req
    end

    def build_url(resource_path)
      "#{@protocol}://#{@subdomain}.floorplanner.com#{@api_path}/#{resource_path}"
    end

    def logger
      self.class.logger
    end

    class Error < StandardError
      attr_reader :response_body

      def initialize(msg, response_body)
        super(msg)
        @response_body = response_body
      end
    end
  end
end
