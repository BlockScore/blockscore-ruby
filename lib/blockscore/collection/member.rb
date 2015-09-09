module BlockScore
  class Collection
    # Member of a {Collection} class
    class Member < SimpleDelegator
      # Initialize a new member
      #
      # @param parent [BlockScore::Base] parent resource
      # @param instance [BlockScore::Base] member instance
      #
      # @return [undefined]
      #
      # @api private
      def initialize(parent, instance)
        @instance = instance
        @parent = parent

        super(instance)
      end

      # Save parent, set parent id, and save instance
      #
      # @example
      #   # saves both unsaved person and unsaved question_set
      #   person = Person.new(attributes)
      #   question_set = QuestionSet.new
      #   Member.new(person, question_set).save
      #
      # @return return value of instance `#save`
      #
      # @api public
      def save
        save_parent
        send(:"#{parent_name}_id=", parent.id)
        instance.save
      end

      private

      # Name of parent resource
      #
      # @example
      #   self.parent_name # => 'person'
      #
      # @return [String]
      #
      # @api private
      def parent_name
        parent.class.resource
      end

      # Save parent if it hasn't already been saved
      #
      # @return return of parent.save if previously unsaved
      # @return nil otherwise
      #
      # @api private
      def save_parent
        parent.save unless parent_saved?
      end

      # Check if parent is saved
      #
      # @return [Boolean]
      #
      # @api private
      def parent_saved?
        parent.id
      end

      # @!attribute [r] instance
      # member instance methods are delegated to
      #
      # @return [BlockScore::Base]
      #
      # @api private
      attr_reader :instance

      # @!attribute [r] parent
      # collection parent the collectino conditionally updates
      #
      # @return [BlockScore::Base]
      #
      # @api private
      attr_reader :parent
    end
  end
end
