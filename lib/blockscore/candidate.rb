require 'blockscore/actions/create'
require 'blockscore/actions/retrieve'
require 'blockscore/actions/all'

module BlockScore
  class Candidate < BlockScore::Base
    include BlockScore::Actions::Create
    include BlockScore::Actions::Retrieve
    include BlockScore::Actions::All
    
    def delete
      self.class.delete "#{self.class.endpoint}/#{id}", {}
    end
    
    def history
      self.class.get "#{self.class.endpoint}/#{id}/history", {}
    end
    
    def hits
      self.class.get "#{self.class.endpoint}/#{id}/hits", {}
    end
  end
end
