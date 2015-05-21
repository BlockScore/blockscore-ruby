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
      resource_member('history')
    end

    def hits
      resource_member('hits')
    end

    private

    def resource_member(member)
      self.class.get "#{self.class.endpoint}#{id}/#{member}", {}
    end
  end
end
