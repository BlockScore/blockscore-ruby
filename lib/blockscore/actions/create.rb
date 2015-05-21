# Public: Provides a :create class method which creates a new instance
# of the desired class using the BlockScore API.
#
# Examples
#
# candidate = BlockScore::Candidate.create(
#   note: "12341234",
#   ssn: "0001",
#   date_of_birth: "1940-08-11",
#   name_first: "John",
#   name_middle: "",
#   name_last: "Bredenkamp",
#   address_street1: "1 Infinite Loop",
#   address_city: "Cupertino",
#   address_country_code: "US"
# )
# => <BlockScore::Candidate:0x007fe39c424410>
#
# Returns an instance of the desired class.
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
