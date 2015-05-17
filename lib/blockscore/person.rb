require 'blockscore/actions/create'
require 'blockscore/actions/retrieve'
require 'blockscore/actions/all'
require 'blockscore/question_set'

module BlockScore
  class Person < Base
    include BlockScore::Actions::Create
    include BlockScore::Actions::Retrieve
    include BlockScore::Actions::All
    
    def initialize(options = {})
      super
      @question_set = BlockScore::QuestionSet.new({ :person_id => id })
    end

    def question_set
      @question_set
    end
  end
end
