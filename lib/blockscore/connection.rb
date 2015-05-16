require 'net/http'
require 'uri'
require 'active_support/core_ext/module/attribute_accessors'

module BlockScore
  module Connection
    ENDPOINT = 'https://api.blockscore.com'

    VERB_MAP = {
      :get    => Net::HTTP::Get,
      :post   => Net::HTTP::Post,
      :put    => Net::HTTP::Put,
      :delete => Net::HTTP::Delete
    }
    
    mattr_accessor :api_key
    
    mattr_accessor :uri #do
      #URI(ENDPOINT)
    #end
    
    mattr_accessor :http #do
      #Net::HTTP.new(uri.host, uri.port)
    #end
    
    # http.use_ssl = true

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

    def request(method, path, params)
      case method
      when :get
        full_path = encode_path_params(path, params)
        request = VERB_MAP[method].new(full_path)
      else
        request = VERB_MAP[method].new(path)
        request.set_form_data(params)
      end

      # get api_key
      request.basic_auth(@@api_key, "")

      # set headers
      request['Accept'] = "application/vnd.blockscore+json;version=4"
      request['User-Agent'] = 'blockscore-ruby/4.1.0 (https://github.com/BlockScore/blockscore-ruby)'

      response = http.request(request)
      options = JSON.parse(response.body)
      if options.class == Array
        # Hits doesnt use the data style
        objects = []
        options.each { |i| objects << create_object(resource, i) }
      elsif options['object'] == 'list'
        objects = []
        options['data'].each do |item|
          objects << create_object(resource, item)
         end
        objects
      else
        create_object(resource, options)
      end
    end

    def create_object(resource, options = {})
      Kernel.const_get("BlockScore::#{resource.camelcase}").new(options)
    end

    def encode_path_params(path, params)
      encoded = URI.encode_www_form(params)
      [path, encoded].join("?")
    end
  end
end
