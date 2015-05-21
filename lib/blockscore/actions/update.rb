# Public: Contains the :save instance method, which updates the object with
# the BlockScore API to persist the changes.
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
module BlockScore
  module Actions
    module Update
      # Public: Saves the changes to the object via an Update call to
      # BlockScore API.
      #
      # Returns true if the update is successful, false otherwise.
      def save
        self.class.patch "#{self.class.endpoint}#{id}", filter_params
        true
      rescue
        false
      end

      # Filters out the non-updateable params
      def filter_params
        # Cannot %i syntax, not introduced until Ruby 2.0.0
        persistent = [:id, :object, :created_at, :updated_at, :livemode, :class]
        @attrs.reject { |k, _| persistent.include?(k) }
      end

      private

      def method_missing(method, *args, &block)
        if respond_to_missing? method
          is_setter = method.to_s[-1] == '='
          if is_setter
            @attrs[method.to_s.chomp('=').to_sym] = args[0]
          else
            @attrs[method]
          end
        else
          super
        end
      end

      def respond_to_missing?(symbol, include_private = false)
        setter = symbol.to_s[0..-2].to_sym
        @attrs && (@attrs.has_key?(symbol) || @attrs.has_key?(setter)) || super
      end
    end
  end
end
