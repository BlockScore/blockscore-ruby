module BlockScore
  module Actions
    # Public: Contains the :save instance method, which saves the
    # object with the BlockScore API to persist the changes unless
    # already saved.
    #
    # Examples
    #
    #  class Foo
    #    include BlockScore::Actions::WriteOnce
    #  end
    #
    #  foo = Foo.new
    #  foo.name_first = 'John'
    #  foo.save
    #  # => true
    #  foo.save
    #  # => false
    module WriteOnce
      extend Forwardable

      def_delegators 'self.class', :resource

      def save!
        saveable? ? super() : failure
      end

      private

      def saveable?
        id.nil?
      end

      def failure
        fail Error, "#{resource} is immutable once saved"
      end

      def add_setter(*)
        saveable? ? super : failure
      end
    end
  end
end
