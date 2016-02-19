module BlockScore
  module Connection
    MAJOR_VERSION = BlockScore::VERSION.split('.').first
    REPO          = 'https://github.com/BlockScore/blockscore-ruby'.freeze
    API_VERSION   = "version=#{MAJOR_VERSION}".freeze
    ACCEPT_HEADER = "application/vnd.blockscore+json;#{API_VERSION}".freeze
    USER_AGENT    = "blockscore-ruby/#{BlockScore::VERSION} (#{REPO})".freeze
    CONTENT_TYPE  = 'application/json'.freeze
    API_URL       = URI.parse('https://api.blockscore.com').freeze
    HEADERS       = {
      'Accept'       => ACCEPT_HEADER,
      'User-Agent'   => USER_AGENT,
      'Content-Type' => CONTENT_TYPE
    }.freeze

    def delete(path, _)
      request(:delete, path, nil)
    end

    private

    def get(path, params)
      request(:get, encode_path_params(path, params), nil)
    end

    def post(path, params)
      request(:post, path, params.to_json)
    end

    def patch(path, params)
      request(:patch, path, params.to_json)
    end

    def request(method, final_endpoint, params)
      begin
        response = execute_request(method,
                                   API_URL + final_endpoint.to_s,
                                   params)
      rescue SocketError, Errno::ECONNREFUSED => e
        fail APIConnectionError, e
      end

      Response.handle_response(resource, response)
    end

    def execute_request(method, path, params)
      options = { basic_auth: authentication, headers: HEADERS, body: params }

      HTTParty.public_send(method, path, options)
    end

    def authentication
      fail NoAPIKeyError, 'No API key was provided.' unless BlockScore.api_key
      { username: BlockScore.api_key }
    end

    def encode_path_params(path, params)
      encoded = URI.encode_www_form(params)
      [path, encoded].join('?')
    end
  end
end
