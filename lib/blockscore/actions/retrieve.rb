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
        def retrieve(id, options={})
          fail ArgumentError if id.empty?
          req = ->() { get("#{endpoint}/#{id}", options) }
          new(&req)
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
