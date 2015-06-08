require 'blockscore/connection'
require 'blockscore/util'

module BlockScore
  class Base
    extend BlockScore::Connection

    attr_reader :attributes

    def initialize(options = {})
      @attributes = options
    end

    def inspect
      "#<#{self.class}:0x#{self.object_id.to_s(16)} JSON: " + JSON.pretty_generate(attributes)
    end

    def refresh
      r = self.class.retrieve(id)
      @attributes = r.attributes

      true
    rescue BlockScore::BlockScoreError
      false
    end

    def self.resource
      @resource ||= Util.to_underscore(to_s.split('::').last)
    end

    def self.api_url
      'https://api.blockscore.com/'
    end

    def self.endpoint
      if self == BlockScore::Base
        fail NotImplementedError, 'Base is an abstract class, not an API resource'
      end

      "#{api_url}#{Util.to_plural(resource)}"
    end

    protected

    def add_accessor(symbol, *args)
      singleton_class.instance_eval do
        define_method(symbol) { attributes[symbol] }
      end
    end

    def add_setter(symbol, *args)
      singleton_class.instance_eval do
        define_method(symbol) do |value|
          attributes[symbol.to_s.chop.to_sym] = value
        end
      end
    end

    private

    def method_missing(method, *args, &block)
      if respond_to_missing? method
        add_accessor(method, args)
        send(method, *args)
      else
        super
      end
    end

    def respond_to_missing?(symbol, include_private = false)
      attributes && attributes.key?(symbol) || super
    end
  end
end
