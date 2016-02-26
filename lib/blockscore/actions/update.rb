module BlockScore
  module Actions
    # Public: Contains the :save instance method, which updates the
    # object with the BlockScore API to persist the changes.
    #
    # Examples
    #
    #  class Candidate
    #    include BlockScore::Actions::Update
    #  end
    #
    #  candidate = Candidate.new
    #  candidate.name_first = 'John'
    #  candidate.save
    #  # => true
    module Update
      extend Forwardable
      def_delegators 'self.class', :patch

      def save!
        persisted? ? update : super()
      end

      private

      def update
        patch(member_endpoint, attributes)
        true
      end
    end
  end
end
