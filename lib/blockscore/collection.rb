module BlockScore
  # Collection is a proxy between the parent and the asssociated members
  # where parent is some instance of a resource
  #
  class Collection < Array
    # @!attribute [r] parent
    # resource which owns a collection of other resources
    #
    # @example
    #   person.question_sets.parent # => person
    #
    # @return [BlockScore::Base] a resource
    #
    # @api private
    attr_reader :parent

    # Sets parent and member_class then registers embedded ids
    #
    # @param [BlockScore::Base] parent
    # @param [Class] class of collection members
    #
    # @return [undefined]
    #
    # @api private
    def initialize(parent, member_class)
      @parent       = parent
      @member_class = member_class
      register_parent_data
    end

    # Syntactic sugar method for returning collection
    #
    # @example
    #   all # returns collection
    #
    # @return [self]
    #
    # @api public
    def all
      self
    end

    # Initializes new {member_class} with `params`
    #
    # - Ensures a parent id is meged into `params` (see #default_params).
    # - Defines method `#save` on new collection member
    # - Adds new item to collection
    #
    # @example usage
    #
    #   >> person = person = BlockScore::Person.retrieve('55de4af7643735000300000f')
    #   >> person.question_sets.new
    #   => #<BlockScore::QuestionSet:0x3fc67902f1b4 JSON:{
    #     "person_id": "55de4af7643735000300000f"
    #   }>
    #
    # @param params [Hash] initial params for member
    #
    # @return instance of {member_class}
    #
    # @api public
    def new(params = {})
      item = member_class.new(params.merge(default_params))
      ctxt = self
      item.define_singleton_method(:save) do
        ctxt.parent.save unless ctxt.parent.id
        send :"#{ctxt.parent_name}_id=", ctxt.parent.id
        super()
      end
      self << item
      item
    end

    # Relaod the contents of the collection
    #
    # @example usage
    #   person.question_sets.refresh # => [#<BlockScore::QuestionSet...]
    #
    # @return [self]
    #
    # @api public
    def refresh
      clear
      register_parent_data
      self
    end

    # Name of parent resource
    #
    # @example
    #   self.parent_name # => 'person'
    #
    # @return [String]
    #
    # @api semipublic
    def parent_name
      parent.class.resource
    end

    # Initialize a collection member and save it
    #
    # @example
    #   >> person.question_sets.create
    #   => #<BlockScore::QuestionSet:0x3fc67a6007f4 JSON:{
    #     "object": "question_set",
    #     "id": "55ef5d5b62386200030001b3",
    #     "created_at": 1441750363,
    #     ...
    #     }
    #
    # @param params [Hash] params
    #
    # @return new saved instance of {member_class}
    #
    # @api public
    def create(params = {})
      fail Error, 'Create parent first' unless parent.id
      assoc_params = default_params.merge(params)
      item = member_class.create(assoc_params)
      register_to_parent(item)
    end

    # Retrieve a collection member by its id
    #
    # @example usage
    #   person.question_sets.retrieve('55ef5b4e3532630003000178') # => instance of QuestionSet
    #
    # @param id [String] resource id
    #
    # @return instance of {member_class} if found
    # @raise [BlockScore::NotFoundError] otherwise
    #
    # @api public
    def retrieve(id)
      return self[ids.index(id)] if ids.include?(id)
      item = member_class.retrieve(id)
      register_to_parent(item)
    end

    protected

    # @!attribute [r] member_class
    # class which will be used for the embedded
    # resources in the collection
    #
    # @return [Class]
    #
    # @api private
    attr_reader :member_class

    # Default params for making an instance of {member_class}
    #
    # @return [Hash]
    #
    # @api private
    def default_params
      {
        :"#{parent_name}_id" => parent.id
      }
    end

    private

    # Check if `parent_id` is defined on `item`
    #
    # @param item [BlockScore::Base] any resource
    #
    # @return [Boolean]
    #
    # @api private
    def parent_id?(item)
      parent.id && item.send(:"#{parent_name}_id") == parent.id
    end

    # Register a resource in collection
    #
    # @param item [BlockScore::Base] a resource
    #
    # @raise [BlockScore::Error] if no `parent_id`
    # @return [BlockScore::Base] otherwise
    #
    # @api private
    def register_to_parent(item)
      fail Error, 'None belonging' unless parent_id?(item)
      ids << item.id
      self << item
      item
    end

    # Fetches embedded ids from parent and adds to self
    #
    # @return [undefined]
    #
    # @api private
    def register_parent_data
      ids.each do |id|
        item = member_class.retrieve(id)
        self << item
      end
    end

    # ids that belong to the collection
    #
    # @return [Array<String>]
    #
    # @api private
    def ids
      parent.attributes.fetch(:"#{Util.to_plural(member_class.resource)}", [])
    end
  end
end
