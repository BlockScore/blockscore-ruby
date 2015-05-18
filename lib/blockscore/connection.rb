require 'json'
require 'active_support/core_ext/module/attribute_accessors'
require 'httparty'
require 'blockscore/error'
require 'blockscore/errors/invalid_request_error'

HEADERS = {
  'Accept' => 'application/vnd.blockscore+json;version=4',
  'User-Agent' => 'blockscore-ruby/4.1.0 (https://github.com/BlockScore/blockscore-ruby)',
  'Content-Type' => 'application/json'
}

module BlockScore
  module Connection
    mattr_accessor :api_key

    def get(path, params)
      request :get, path, params
    end

    def post(path, params)
      request :post, path, params
    end

    def patch(path, params)
      request :patch, path, params
    end

    def put(path, params)
      request :put, path, params
    end

    def delete(path, params)
      request :delete, path, params
    end
    
    private

    def request(method, path, params)
      response = execute_request(method, path, params)

      case response.code
      when 200, 201
        json_obj = parse_json(response)

        if json_obj.class == Array
          build_response_from_arr json_obj
        elsif json_obj[:object] == 'list'
          build_response_from_arr json_obj[:data]
        else
          create_object(resource, json_obj)
        end
      else
        handle_api_error(response.code, response.body)
      end
    end

    def execute_request(method, path, params)
      auth = { :username => @@api_key, :password => '' }
      headers = HEADERS

      options = { :basic_auth => auth, :headers => headers, :body => params.to_json }

      HTTParty.send(method, path, options) 
    end
    
    def parse_json(response)
      begin
        response = JSON.parse(response.body, :symbolize_names => true)
      rescue JSON::ParserError
        raise general_api_error(response.code.to_i, response.body)
      end
    end

    def build_response_from_arr(arr_obj)
      arr_obj.map { |obj| create_object(resource, obj) }
    end

    def create_object(resource, options = {})
      Kernel.const_get("BlockScore::#{resource.camelcase}").new(options)
    end

    def general_api_error(rcode, rbody)
      APIError.new("Invalid response object from API: #{rbody.inspect} " +
                   "(HTTP response code was #{rcode})", rcode, rbody)
    end

    def handle_api_error(rcode, rbody)
      begin
        error_obj = JSON.parse(rbody, :symbolize_names => true)
        error = error_obj[:error] or raise BlockScore::BlockScoreError.new

      rescue JSON::ParserError, BlockScore::BlockScoreError
        raise general_api_error(rcode, rbody)
      end

      case rcode
      when 400, 404
        raise invalid_request_error(error, rcode, rbody, error_obj)
      when 401
        raise authentication_error(error, rcode, rbody, error_obj)
      else
        raise api_error(error, rcode, body, error_obj)
      end
    end

    def invalid_request_error(error, rcode, rbody, error_obj)
      BlockScore::InvalidRequestError.new(error[:message], error[:param],
                                          rcode, rbody, error_obj)
    end

    def authentication_error(error, rcode, rbody, error_obj)
      BlockScore::AuthenticationError.new(error[:message], rcode, rbody,
                                          error_obj)
    end

    def api_error(error, rcode, rbody, error_obj)
      BlockScore::APIError.new(error[:message], rcode, rbody, error_obj)
    end
  end
end
