require 'blockscore/actions/create'
require 'blockscore/actions/retrieve'
require 'blockscore/actions/all'

module BlockScore
  class QuestionSet < Base
    include BlockScore::Actions::Create
    include BlockScore::Actions::Retrieve
    include BlockScore::Actions::All

    def create(params)
      self.class.create(params)
    end

    def retrieve(id)
      self.class.retrieve(id)
    end

    def all(options = {})
      self.class.all(options)
    end
    
    def score(answers)
      self.class.post "#{self.class.endpoint}#{id}/score", :answers => answers
    end

    def create
      self.class.create(:person_id => person_id)
    end
  end
end
