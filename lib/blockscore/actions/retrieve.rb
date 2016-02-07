module BlockScore
  module Actions
    # Public: Provides a :retrieve class method to including classes.
    #
    # Returns a instance of the desired class on success, raises an
    # appropriate error otherwise.
    #
    # Examples
    #
    # person = BlockScore::Person.retrieve('abc123def456')
    # => #<BlockScore::Person:0x007fe39c424410>
    module Retrieve
      module ClassMethods
        RESOURCE_ID_FORMAT = /\A[a-f0-9]+\z/.freeze

        def retrieve(id, options = {})
          fail ArgumentError, 'ID must be supplied' if id.nil? || id.empty?
          fail ArgumentError, 'ID is malformed' unless id =~ RESOURCE_ID_FORMAT
          req = ->() { get("#{endpoint}/#{id}", options) }
          new(id: id, &req)
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
