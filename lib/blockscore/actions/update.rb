module BlockScore
  module Actions
    # Public: Contains the :save instance method, which updates the
    # object with the BlockScore API to persist the changes.
    #
    # Examples
    #
    #  class Foo
    #    include BlockScore::Actions::Update
    #  end
    #
    #  foo = Foo.new
    #  foo.name_first = 'John'
    #  foo.save
    #  # => true
    module Update
      extend Forwardable

      # Attributes which will not change once the object is created.
      PERSISTENT_ATTRIBUTES = [
        :id,
        :object,
        :created_at,
        :updated_at,
        :livemode
      ]

      def_delegators 'self.class', :endpoint, :patch

      def save!
        if respond_to? :id
          patch "#{endpoint}/#{id}", filter_params
          true
        else
          super
        end
      end

      # Filters out the non-updateable params.
      def filter_params
        # Cannot %i syntax, not introduced until Ruby 2.0.0
        attributes.reject { |key, _| PERSISTENT_ATTRIBUTES.include?(key) }
      end

      private

      def method_missing(method, *args, &block)
        if respond_to_missing? method
          if method.to_s.end_with? '='
            add_setter(method, *args)
          else
            add_accessor(method, *args)
          end
          send(method, *args)
        else
          super
        end
      end

      def respond_to_missing?(symbol, include_private = false)
        setter = symbol.to_s[0..-2].to_sym
        attributes && (attributes.key?(symbol) || attributes.key?(setter)) || super
      end
    end
  end
end
