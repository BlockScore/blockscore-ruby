require 'blockscore/question_set'

module BlockScore
  class Person < Base
    def initialize(options = {})
      super
      @question_set = BlockScore::QuestionSet.new({ :person_id => id })
    end

    def question_set
      @question_set
    end
  end
end
