require 'json'
require 'active_support/core_ext/module/attribute_accessors'
require 'httparty'
require 'blockscore/version'
require 'blockscore/responder'
require 'blockscore/errors/api_error'
require 'blockscore/errors/authentication_error'
require 'blockscore/errors/blockscore_error'
require 'blockscore/errors/invalid_request_error'

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
        'Accept' => "application/vnd.blockscore+json;version=#{BlockScore::VERSION.to_i}",
        'User-Agent' => 'blockscore-ruby/4.1.0 (https://github.com/BlockScore/blockscore-ruby)',
        'Content-Type' => 'application/json'
      }
    end

    def request(method, path, params)
      if @@api_key.nil?
        fail BlockScore::AuthenticationError, {
          :error => { :message => "No API key was provided." }
        }
      end

      response = execute_request(method, path, params)

      handle_response(response)
    end

    def execute_request(method, path, params)
      auth = { :username => @@api_key, :password => '' }

      if method == :get
        path = encode_path_params(path, params)
        params = nil
      else
        params = params.to_json
      end

      options = { :basic_auth => auth, :headers => headers, :body => params }

      HTTParty.send(method, path, options)
    end

    def encode_path_params(path, params)
      encoded = URI.encode_www_form(params)
      [path, encoded].join("?")
    end
  end
end
