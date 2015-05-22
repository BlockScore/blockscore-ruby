require 'json'
require 'active_support/core_ext/module/attribute_accessors'
require 'active_support/core_ext/string/inflections'
require 'httparty'
require 'blockscore/responder'

module BlockScore
  module Connection
    include BlockScore::Responder
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

    def headers
      @@headers ||= {
        'Accept' => 'application/vnd.blockscore+json;version=4',
        'User-Agent' => 'blockscore-ruby/4.1.0 (https://github.com/BlockScore/blockscore-ruby)',
        'Content-Type' => 'application/json'
      }
    end

    def request(method, path, params)
      response = execute_request(method, path, params)

      handle_response(response)
    end

    def execute_request(method, path, params)
      auth = { :username => @@api_key, :password => '' }

      options = { :basic_auth => auth, :headers => headers, :body => params.to_json }

      HTTParty.send(method, path, options)
    end
  end
end
