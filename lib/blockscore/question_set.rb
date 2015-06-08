require 'blockscore/actions/create'
require 'blockscore/actions/retrieve'
require 'blockscore/actions/all'
require 'forwardable'

module BlockScore
  class QuestionSet < Base
    extend Forwardable

    include BlockScore::Actions::Create
    include BlockScore::Actions::Retrieve
    include BlockScore::Actions::All

    def_delegators 'self.class', :retrieve, :all, :post, :endpoint

    def create
      self.class.create(:person_id => person.id)
    end

    def score(answers = nil)
      if answers.nil? && attributes
        attributes[:score]
      else
        post "#{endpoint}/#{id}/score", :answers => answers
      end
    end
  end
end
