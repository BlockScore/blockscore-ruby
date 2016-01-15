module BlockScore
  module Connection
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
        'Accept' => "application/vnd.blockscore+json;version=#{BlockScore::VERSION.to_i}",
        'User-Agent' => "blockscore-ruby/#{BlockScore::VERSION} (https://github.com/BlockScore/blockscore-ruby)",
        'Content-Type' => 'application/json'
      }
    end

    def request(method, path, params)
      api_key = params.delete(:api_key) || BlockScore.api_key
      fail NoAPIKeyError, 'No API key was provided.' unless api_key

      begin
        response = execute_request(method, path, params, api_key)
      rescue SocketError, Errno::ECONNREFUSED => e
        raise APIConnectionError, e.message
      end

      Response.handle_response(resource, response)
    end

    def execute_request(method, path, params, api_key)
      auth = { username: api_key, password: '' }

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
