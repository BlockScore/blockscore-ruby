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
      # Attributes which will not change once the object is created.
      PERSISTENT_ATTRIBUTES = [
        :id,
        :object,
        :created_at,
        :updated_at,
        :livemode
      ]

      # Public: Saves the changes to the object via an Update call to
      # BlockScore API.
      #
      # Returns true if the update is successful, false otherwise.
      def save
        save!
      rescue
        false
      end

      def save!
        self.class.patch "#{self.class.endpoint}#{id}", filter_params

        true
      end

      # Filters out the non-updateable params.
      def filter_params
        # Cannot %i syntax, not introduced until Ruby 2.0.0
        attributes.reject { |k, _| PERSISTENT_ATTRIBUTES.include?(k) }
      end

      private

      def method_missing(method, *args, &block)
        if respond_to_missing? method
          is_setter = method.to_s[-1] == '='
          if is_setter
            @attributes[method.to_s.chomp('=').to_sym] = args[0]
          else
            attributes[method]
          end
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
