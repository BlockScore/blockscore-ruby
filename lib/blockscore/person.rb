module BlockScore
  class Person < Base
    include BlockScore::Actions::Create
    include BlockScore::Actions::Retrieve
    include BlockScore::Actions::All

    attr_reader :question_set

    def initialize(options = {})
      super
      @question_set = QuestionSet.new :person => self
    end
  end
end
