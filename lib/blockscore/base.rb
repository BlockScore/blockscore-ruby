require 'blockscore/connection'
require 'uri'

module BlockScore
  class Base
    extend Connection
    extend Forwardable

    ABSTRACT_WARNING = 'Base is an abstract class, not an API resource'.freeze
    IMMUTABLE_ATTRS  = %i(id object created_at updated_at livemode deleted).freeze

    def_delegators 'self.class', :endpoint, :post, :retrieve, :resource

    def initialize(options = {}, &block)
      @loaded     = !block
      @proc       = block
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
    rescue Error
      false
    end

    def save!
      assert_not_deleted
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

    def deleted?
      attributes.fetch(:deleted, false)
    end

    private

    def assert_not_deleted
      fail Error, "#{resource} is already deleted" if deleted?
    end

    def capture_attributes(source)
      @attributes = source.attributes
    end

    def add_accessor(symbol)
      singleton_class.instance_eval do
        define_method(symbol) do
          wrap_attribute(attributes.fetch(symbol))
        end
      end
    end

    def add_setter(symbol)
      attr = symbol.to_s.chop.to_sym
      assert_mutable(attr)
      singleton_class.instance_eval do
        define_method(symbol) do |value|
          attributes[attr] = value
        end
      end
    end

    def force!
      @attributes = @proc.call.attributes
      @loaded     = true
    end

    def method_missing(method, *args)
      super unless respond_to_missing?(method)
      if setter?(method)
        add_setter(method)
      else
        add_accessor(method)
      end
      public_send(method, *args)
    end

    def assert_mutable(attr)
      fail NoMethodError, "#{attr} is immutable" if IMMUTABLE_ATTRS.include?(attr)
    end

    def respond_to_missing?(symbol, *)
      setter?(symbol) || attributes.key?(symbol)
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
