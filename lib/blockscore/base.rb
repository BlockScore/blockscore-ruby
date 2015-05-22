require 'active_support/core_ext/class'
require 'active_support/core_ext/string/inflections'
require 'blockscore/connection'

module BlockScore
  class Base
    extend BlockScore::Connection

    class_attribute :api_key, :resource, :version

    attr_reader :attributes

    def self.inherited(base)
      base.resource = base.to_s.split('::').last.underscore
    end

    def initialize(options = {})
      @attributes = options
    end

    def refresh
      self.class.retrieve(id)
      @attributes = r.attributes

      true
    rescue BlockScore::BlockScoreError
      false
    end

    def self.auth(api_key)
      self.api_key = api_key
      BlockScore::Connection.api_key = api_key
    end

    def self.api_url
      'https://api.blockscore.com/'
    end

    def self.endpoint
      if self == BlockScore::Base
        fail NotImplementedError, 'Base is an abstract class, not an API resource'
      end

      "#{api_url}#{resource.pluralize}"
    end

    def method_missing(method, *args, &block)
      if respond_to_missing? method
        attributes[method]
      else
        super
      end
    end

    def respond_to_missing?(symbol, include_private = false)
      attributes && attributes.key?(symbol) || super
    end
  end
end
