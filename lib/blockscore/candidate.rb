module BlockScore
  class Candidate < BlockScore::Base
    extend Forwardable

    include BlockScore::Actions::Create
    include BlockScore::Actions::Retrieve
    include BlockScore::Actions::Update
    include BlockScore::Actions::Delete
    include BlockScore::Actions::All

    def_delegators 'self.class', :api_url, :endpoint, :get, :post

    def history
      resource_member 'history'
    end

    def hits
      resource_member 'hits'
    end

    def search(options = {})
      options[:candidate_id] = id
      post "#{api_url}watchlists", options
    end

    private

    def resource_member(member)
      get "#{endpoint}/#{id}/#{member}", {}
    end
  end
end
