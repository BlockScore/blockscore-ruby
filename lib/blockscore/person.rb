module BlockScore
  class Person < Base
    include BlockScore::Actions::Create
    include BlockScore::Actions::Retrieve
    include BlockScore::Actions::All

    attr_reader :question_sets

    def initialize(options = {})
      super
      @question_sets = QuestionSet.new(:person => self)
    end
  end
end
