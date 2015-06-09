require 'blockscore/connection'

module BlockScore
  class Base
    extend Connection

    attr_reader :attributes

    def initialize(options = {})
      @attributes = options
    end

    def inspect
      "#<#{self.class}:0x#{object_id.to_s(16)} JSON: " + JSON.pretty_generate(attributes)
    end

    def refresh
      r = self.class.retrieve(id)
      @attributes = r.attributes

      true
    rescue Error
      false
    end

    def save
      save!
    rescue
      false
    end

    def save!
      response = self.class.post self.class.endpoint, attributes
      @attributes[:id] = response.id

      refresh
    end

    def self.resource
      @resource ||= Util.to_underscore(to_s.split('::').last)
    end

    def self.api_url
      'https://api.blockscore.com/'
    end

    def self.endpoint
      if self == Base
        fail NotImplementedError, 'Base is an abstract class, not an API resource'
      end

      "#{api_url}#{Util.to_plural(resource)}"
    end

    protected

    def add_accessor(symbol, *args)
      singleton_class.instance_eval do
        define_method(symbol) do
          if attributes[symbol].is_a? Hash
            OpenStruct.new attributes[symbol]
          else
            attributes[symbol]
          end
        end
      end
    end

    def add_setter(symbol, *_args)
      singleton_class.instance_eval do
        define_method(symbol) do |value|
          attributes[symbol.to_s.chop.to_sym] = value
        end
      end
    end

    private

    def method_missing(method, *args, &block)
      if respond_to_missing? method
        if setter? method
          add_setter(method, args)
        else
          add_accessor(method, args)
        end
        send(method, *args)
      else
        super
      end
    end

    def respond_to_missing?(symbol, include_private = false)
      setter?(symbol) || attributes && attributes.key?(symbol) || super
    end

    def setter?(symbol)
      symbol.to_s.end_with? '='
    end
  end
end
