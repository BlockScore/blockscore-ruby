module BlockScore
  module Actions
    module Update
      def update(params)
        self.class.patch "#{self.class.endpoint}#{id}", params
        refresh
        
        self
      end
    end
  end
end
