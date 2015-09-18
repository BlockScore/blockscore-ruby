module BlockScore
  class QuestionSet < Base
    extend Forwardable

    include BlockScore::Actions::Create
    include BlockScore::Actions::Retrieve
    include BlockScore::Actions::All

    def_delegators 'self.class', :post, :endpoint

    def score(answers = nil)
      if answers.nil? && attributes
        attributes[:score]
      else
        @attributes = post("#{endpoint}/#{id}/score", answers: answers).attributes
        self
      end
    end
  end
end
