module BlockScore
  module Connection
    MAJOR_VERSION = BlockScore::VERSION.split('.').first
    REPO          = 'https://github.com/BlockScore/blockscore-ruby'.freeze
    API_VERSION   = "version=#{MAJOR_VERSION}".freeze
    ACCEPT_HEADER = "application/vnd.blockscore+json;#{API_VERSION}".freeze
    USER_AGENT    = "blockscore-ruby/#{BlockScore::VERSION} (#{REPO})".freeze
    CONTENT_TYPE  = 'application/json'.freeze
    API_URL       = URI.parse('https://api.blockscore.com').freeze

    def get(path, params)
      request(:get, path, params)
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

    def request(method, endpoint, params)
      fail NoAPIKeyError, 'No API key was provided.' unless BlockScore.api_key

      path = API_URL + endpoint.to_s

      begin
        response = execute_request(method, path, params)
      rescue SocketError, Errno::ECONNREFUSED => e
        raise APIConnectionError, e.message
      end

      Response.handle_response(resource, response)
    end

    def execute_request(method, path, params)
      auth = { username: BlockScore.api_key, password: '' }

      params = if method.equal?(:get)
                 path = encode_path_params(path, params)
                 nil
               else
                 params.to_json
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
