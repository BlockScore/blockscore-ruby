require 'blockscore/connection'
require 'uri'

module BlockScore
  class Base
    extend Connection
    extend Forwardable

    ABSTRACT_WARNING = 'Base is an abstract class, not an API resource'.freeze

    def_delegators 'self.class', :endpoint, :post, :retrieve, :resource

    def initialize(options = {}, &block)
      @loaded = !(block)
      @proc = block
      @attributes = options
    end

    def attributes
      return @attributes if @loaded
      force!
      attributes
    end

    def id
      attributes[:id]
    end

    def inspect
      str_attr = "JSON:#{JSON.pretty_generate(attributes)}"
      "#<#{self.class}:#{format('%#016x', object_id << 1)} #{str_attr}>"
    end

    def save
      save!
    rescue BlockScore::Error
      false
    end

    def save!
      fail BlockScore::Error, "#{resource} is already deleted" if deleted?
      capture_attributes(post(endpoint, attributes))
      true
    end

    def self.resource
      @resource ||= Util.to_underscore(to_s.split('::').last)
    end

    def self.endpoint
      fail NotImplementedError, ABSTRACT_WARNING if equal?(Base)
      Pathname(Util.to_plural(resource))
    end

    def member_endpoint
      endpoint + id
    end

    def persisted?
      !id.nil? && !deleted?
    end

    private

    def capture_attributes(source)
      @attributes = source.attributes
    end

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

    def deleted?
      attributes.fetch(:deleted, false)
    end

    def force!
      @attributes = @proc.call.attributes.merge(@attributes)
      @loaded = true
    end

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
