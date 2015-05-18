require 'json'
require 'uri'
require 'active_support/core_ext/module/attribute_accessors'
require 'httparty'
require 'blockscore/error'
require 'blockscore/utils'

module BlockScore
  module Connection
    include HTTParty
    base_uri 'https://api.blockscore.com'
    
    mattr_accessor :api_key
    mattr_accessor :uri    
    mattr_accessor :http
    
    def get(path, params)
      request :get, path, params
    end

    def post(path, params)
      request :post, path, params
    end

    def put(path, params)
      request :put, path, params
    end

    def delete(path, params)
      request :delete, path, params
    end

    private

    # Wrap HTTParty requests
    def request(method, path, params)
      if method == :get
        path = encode_path_params(path, params)
        payload = nil
      else
        payload = JSON.generate(params)
      end

      # set headers
      headers = {
        'Accept' => 'application/vnd.blockscore+json;version=4',
        'User-Agent' => 'blockscore-ruby/4.1.0 (https://github.com/BlockScore/blockscore-ruby)'
      }

      response = execute_request(method, path, @@api_key, headers, payload)

      case response.code
      when 200, 201
        # All BlockScore API successes return 200 or 201.
        json_obj = parse_json(response)

        if json_obj.class == Array
          # candidates#hits the only endpoint not using data format
          objects = []
          json_obj.each { |obj| objects << create_object(resource, obj) }
        elsif json_obj[:object] == 'list'
          objects = []
          json_obj[:data].each do |obj|
            
            objects << create_object(resource, obj)
          end
          
          objects
        else
          create_object(resource, json_obj)
        end
      else
        handle_api_error(response.code, response.body)
      end
    end

    def execute_request(method, path, api_key, headers, payload)
      auth = { :username => api_key, :password => '' }
      options = { :body => payload, :headers => headers, :basic_auth => auth }
      
    end
    
    def create_object(resource, options = {})
      Kernel.const_get("BlockScore::#{resource.camelcase}").new(options)
    end
    
    # Expects Net::HTTP response object
    def parse_json(response)
      begin
        response = JSON.parse(response.body, :symbolize_names => true)
      rescue JSON::ParseError
        raise general_api_error(response.code.to_i, response.body)
      end
    end

    def general_api_error(rcode, rbody)
      APIError.new("Invalid response object from API: #{rbody.inspect} " +
                   "(HTTP response code was #{rcode})", rcode, rbody)
    end

    def handle_api_error(rcode, rbody)
      begin
        error_obj = JSON.parse(rbody, :symbolize_names => true)
        error = error_obj[:error] or raise BlockScore::BlockScoreError.new

      rescue JSON::ParseError, BlockScore::BlockScoreError
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
