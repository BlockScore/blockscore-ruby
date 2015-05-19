module BlockScore
  module Actions
    module All
      module ClassMethods
        def all(options = {})
          get endpoint, options
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
