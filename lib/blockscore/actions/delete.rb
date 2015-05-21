module BlockScore
  module Actions
    module Delete
      def delete(id, options = {})
        self.class.delete "#{self.class.endpoint}#{id}", options
      end
    end
  end
end
