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
      @attrs = options
    end

    def refresh
      self.class.retrieve(id)
      instance_variable_set(:@attrs, r.instance_variable_get(:@attrs))

      true
    rescue BlockScore::BlockScoreError
      false
    end

    def self.auth(key)
      api_key = key
      BlockScore::Connection.api_key = key
    end

    def self.api_url
      'https://api.blockscore.com/'
    end

    def self.endpoint
      if self == BlockScore::Base
        fail NotImplementedError.new('Base is an abstract class, not an ' +
                                     'API resource')
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
      @attrs && @attrs.key?(symbol) || super
    end
  end
end
