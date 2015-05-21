require 'blockscore/actions/create'
require 'blockscore/actions/retrieve'
require 'blockscore/actions/update'
require 'blockscore/actions/delete'
require 'blockscore/actions/all'

module BlockScore
  class Candidate < BlockScore::Base
    include BlockScore::Actions::Create
    include BlockScore::Actions::Retrieve
    include BlockScore::Actions::Update
    include BlockScore::Actions::Delete
    include BlockScore::Actions::All

    def history
      self.class.get "#{self.class.endpoint}#{id}/history", {}
    end

    def hits
      self.class.get "#{self.class.endpoint}#{id}/hits", {}
    end
  end
end
