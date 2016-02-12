module BlockScore
  class Candidate < BlockScore::Base
    extend Forwardable

    include BlockScore::Actions::Create
    include BlockScore::Actions::Retrieve
    include BlockScore::Actions::Update
    include BlockScore::Actions::Delete
    include BlockScore::Actions::All

    def_delegators 'self.class', :get, :post

    def history
      resource_member 'history'
    end

    def hits
      resource_member 'hits'
    end

    def search(options = {})
      post 'watchlists', options.merge(candidate_id: id)
    end

    private

    def resource_member(target)
      get member_endpoint + target, {}
    end
  end
end
