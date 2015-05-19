module BlockScore
  module Actions
    module Create
      module ClassMethods
        def create(params = {})
          post(endpoint, params)
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
