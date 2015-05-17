require 'active_support/core_ext/class'
require 'active_support/core_ext/string/inflections'
require 'blockscore/connection'

module BlockScore
  class Base
    extend BlockScore::Connection
    
    class_attribute :api_key, :resource, :version
    # version = 4

    def self.inherited(base)       
      # i.e. for BlockScore::Verification, we want 'verification'
      base.resource = base.to_s.split('::').last.underscore
    end

    # @options - Hash of attributes for the object.
    def initialize(options = {})
      options['class'] = resource
      @attrs = options
    end

    def self.auth(api_key)
      api_key = api_key
      BlockScore::Connection.api_key = api_key
      BlockScore::Connection.uri = URI('https://api.blockscore.com')
      BlockScore::Connection.http = Net::HTTP.new(uri.host, uri.port)
      BlockScore::Connection.http.use_ssl = true
    end
    
    def self.api_url
      'https://api.blockscore.com/'
    end

    def self.endpoint
      "#{api_url}#{resource.pluralize}/"
    end

    # To expose the @attrs as top-level methods.
    def method_missing(method, *args, &block)
      if respond_to_missing? method
        @attrs[method.to_s]
      else
        super
      end
    end

    def respond_to_missing?(symbol, include_private = false)
      @attrs && @attrs.has_key?(symbol.to_s) || super
    end
  end
end
