module BlockScore
  module Actions
    # Public: Provides an :all action to including Classes.
    #
    # The :all method returns up to 25 items from the BlockScore API for
    # the given class.
    #
    # :all accepts an options hash, which responds to the following options:
    #
    # count - Fixnum number of items to return per page.
    # offset - Fixnum number of items to skip before returning @count items.
    #
    # If no count is provided, 25 items are returned, or all items if the total
    # number of items is 25 of fewer.
    module All
      module ClassMethods
        def all(options = {})
          get(endpoint, options)
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
