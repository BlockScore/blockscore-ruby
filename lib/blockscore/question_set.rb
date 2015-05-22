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

    def_delegators 'self.class', :retrieve, :all

    def create
      self.class.create(:person_id => person_id)
    end

    def score(answers)
      self.class.post "#{self.class.endpoint}/#{id}/score", :answers => answers
    end
  end
end
