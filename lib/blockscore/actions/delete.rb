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
      extend Forwardable

      def_delegators 'self.class', :endpoint

      def delete
        delete!
      rescue BlockScore::Error
        false
      end

      def delete!
        self.class.delete "#{endpoint}/#{id}", {}
        @attributes[:deleted] = true
        true
      end
    end
  end
end
