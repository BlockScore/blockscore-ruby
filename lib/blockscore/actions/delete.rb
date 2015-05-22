module BlockScore
  module Actions
    # Provides a :delete instance method to including classes.
    #
    # Returns the updated object with deleted == true.
    #
    # Examples
    #
    # candidate.delete
    # => #<BlockScore::Candidate:0x007fe39c424410>
    module Delete
      def delete
        self.class.delete "#{self.class.endpoint}#{id}", {}
        @attributes[:deleted] = true
        true
      rescue BlockScore::BlockScoreError
        false
      end
    end
  end
end
