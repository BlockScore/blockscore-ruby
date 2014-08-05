module BlockScore
  class Watchlist
    def initialize(client)
      @client = client
    end
    # POST https://api.blockscore.com/watchlists
    def search(watchlist_candidate_id, match_type = nil)
      body = {}
      body[:watchlist_candidate_id] = watchlist_candidate_id
      body[:match_type] = match_type

      @client.post '/watchlists', body
    end
  end
end