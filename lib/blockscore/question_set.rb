require 'blockscore/actions/create'
require 'blockscore/actions/retrieve'
require 'blockscore/actions/all'

module BlockScore
  class QuestionSet < Base
    include BlockScore::Actions::Create
    include BlockScore::Actions::Retrieve
    # should limit the index to the current Person's QuestionSets...
    include BlockScore::Actions::All

    
    def score(answers)
      self.class.post "#{self.class.endpoint}#{id}/score", :answers => answers
    end

    def create
      self.class.create(:person_id => person_id)
    end
  end
end
