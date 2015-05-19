require 'active_support/core_ext/class'
require 'active_support/core_ext/string/inflections'
require 'blockscore/connection'

module BlockScore
  class Base
    extend BlockScore::Connection
    
    class_attribute :api_key, :resource, :version

    def self.inherited(base)       
      base.resource = base.to_s.split('::').last.underscore
    end

    def initialize(options = {})
      options[:class] = resource
      @attrs = options
    end

    def refresh
      r = self.class.retrieve(id)
      if r != BlockScoreError
        instance_variable_set(:@attrs, r.instance_variable_get(:@attrs))

        true
      else
        false
      end
    end

    def self.auth(api_key)
      api_key = api_key
      BlockScore::Connection.api_key = api_key
    end
    
    def self.api_url
      'https://api.blockscore.com/'
    end

    def self.endpoint
      if self == BlockScore::Base
        raise NotImplementedError.new('Base is an abstract class. You should perform actions on its subclasses (Candidate, Company, Person, etc.)')
      end
      
      "#{api_url}#{resource.pluralize}/"
    end

    def method_missing(method, *args, &block)
      if respond_to_missing? method
        @attrs[method]
      else
        super
      end
    end

    def respond_to_missing?(symbol, include_private = false)
      @attrs && @attrs.has_key?(symbol) || super
    end
  end
end
