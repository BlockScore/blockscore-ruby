module BlockScore
  class Candidate < BlockScore::Base
    extend Forwardable

    include BlockScore::Actions::Create
    include BlockScore::Actions::Retrieve
    include BlockScore::Actions::Update
    include BlockScore::Actions::Delete
    include BlockScore::Actions::All

    def_delegators 'self.class', :endpoint, :get, :post

    def history
      resource_member 'history'
    end

    def hits
      resource_member 'hits'
    end

    def search(options = {})
      post uri, options.merge(candidate_id: id)
    end

    def uri
      API_URL + 'watchlists'
    end

    private

    def resource_member(member)
      get "#{endpoint}/#{id}/#{member}", {}
    end
  end
end
