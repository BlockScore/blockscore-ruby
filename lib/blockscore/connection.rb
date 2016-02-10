module BlockScore
  module Connection
    MAJOR_VERSION = BlockScore::VERSION.to_i
    REPO          = 'https://github.com/BlockScore/blockscore-ruby'.freeze
    API_VERSION   = "version=#{MAJOR_VERSION}".freeze
    ACCEPT_HEADER = "application/vnd.blockscore+json;#{API_VERSION}".freeze
    USER_AGENT    = "blockscore-ruby/#{BlockScore::VERSION} (#{REPO})".freeze
    CONTENT_TYPE  = 'application/json'.freeze

    def get(path, params)
      request :get, path, params
    end

    def post(path, params)
      request(:post, path, params)
    end

    def patch(path, params)
      request(:patch, path, params)
    end

    def delete(path, params)
      request(:delete, path, params)
    end

    private

    def headers
      @headers ||= {
        'Accept'       => ACCEPT_HEADER,
        'User-Agent'   => USER_AGENT,
        'Content-Type' => CONTENT_TYPE
      }
    end

    def request(method, path, params)
      fail NoAPIKeyError, 'No API key was provided.' unless BlockScore.api_key

      begin
        response = execute_request(method, path, params)
      rescue SocketError, Errno::ECONNREFUSED => e
        raise APIConnectionError, e.message
      end

      Response.handle_response(resource, response)
    end

    def execute_request(method, path, params)
      auth = { username: BlockScore.api_key, password: '' }

      if method == :get
        path = encode_path_params(path, params)
        params = nil
      else
        params = params.to_json
      end

      options = { basic_auth: auth, headers: headers, body: params }

      HTTParty.send(method, path, options)
    end

    def encode_path_params(path, params)
      encoded = URI.encode_www_form(params)
      [path, encoded].join('?')
    end
  end
end
