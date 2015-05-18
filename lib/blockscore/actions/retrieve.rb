module BlockScore
  module Actions
    module Retrieve
      module ClassMethods
        def retrieve(id)
          get "#{endpoint}#{id}", {}
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
