module BlockScore
  class QuestionSet < Base
    extend Forwardable

    include BlockScore::Actions::Create
    include BlockScore::Actions::Retrieve
    include BlockScore::Actions::All

    def_delegators 'self.class', :post, :endpoint

    def score(answers = nil)
      rescore(answers) if answers
      attributes.fetch(:score)
    end

    private

    def rescore(answers)
      @attributes = post("#{endpoint}/#{id}/score", answers: answers).attributes
    end
  end
end
