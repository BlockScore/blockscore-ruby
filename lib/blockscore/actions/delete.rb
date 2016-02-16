require 'forwardable'

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
        delete!
      rescue Error
        false
      end

      def delete!
        assert_not_deleted
        self.class.delete(member_endpoint, {})
        attributes[:deleted] = true
      end
    end
  end
end
