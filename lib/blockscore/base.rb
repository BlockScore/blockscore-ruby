require 'blockscore/connection'

module BlockScore
  class Base
    extend Connection

    def initialize(options = {}, &block)
      @loaded = !(block)
      @proc = block
      @attributes = options
    end

    def attributes
      return @attributes if @loaded
      force!
      @attributes
    end

    def force!
      res = @proc.call
      @attributes = res.attributes.merge(@attributes)
      @loaded = true
      self
    end

    def id
      @attributes.fetch(:id, nil)
    end

    def inspect
      str_attr = "JSON:#{JSON.pretty_generate(attributes)}"
      "#<#{self.class}:#{format('%#016x', object_id << 1)} #{str_attr}>"
    end

    def refresh
      res = self.class.retrieve(id)
      @attributes = res.attributes

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
      response = self.class.post(self.class.endpoint, attributes)
      @attributes = response.attributes

      true
    end

    def self.resource
      @resource ||= Util.to_underscore(to_s.split('::').last)
    end

    def self.api_url
      'https://api.blockscore.com/'
    end

    def self.endpoint
      fail NotImplementedError, 'Base is an abstract class, not an API resource' if equal?(Base)

      "#{api_url}#{Util.to_plural(resource)}"
    end

    def persisted?
      !id.nil? && !attributes[:deleted]
    end

    protected

    def add_accessor(symbol, *_args)
      singleton_class.instance_eval do
        define_method(symbol) do
          wrap_attribute(attributes[symbol])
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

    # Reinitializes an object based on a hash of values.
    def initialize_from(values)
      @attributes = values
    end

    private

    def method_missing(method, *args, &block)
      if respond_to_missing?(method)
        if setter?(method)
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
      symbol.to_s.end_with?('=')
    end

    def wrap_attribute(attribute)
      case attribute
      when Array
        wrap_array(attribute)
      when Hash
        wrap_hash(attribute)
      else
        attribute
      end
    end

    def wrap_array(arr)
      arr.map { |item| wrap_attribute(item) }
    end

    def wrap_hash(hsh)
      hsh.each { |key, value| hsh[key] = wrap_attribute(value) }

      OpenStruct.new(hsh)
    end
  end
end
