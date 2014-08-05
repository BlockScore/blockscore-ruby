module BlockScore
  class WatchlistCandidate
    def initialize(client)
      @client = client
    end

    # POST https://api.blockscore.com/watchlist_candidates
    def create(options = {})
      response = @client.post '/watchlist_candidates', options
    end

    # PATCH https://api.blockscore.com/watchlist_candidates/{WATCHLIST_CANDIDATE_ID}
    def edit(watchlist_candidate_id, options = {})
      response = @client.put "/watchlist_candidates/#{watchlist_candidate_id}", options 
    end

    # DELETE https://api.blockscore.com/watchlist_candidates/{WATCHLIST_CANDIDATE_ID}
    def delete(watchlist_candidate_id)
      response = @client.delete "/watchlist_candidates/#{watchlist_candidate_id}"
    end

    # GET https://api.blockscore.com/watchlist_candidates/{WATCHLIST_CANDIDATE_ID}
    def retrieve(watchlist_candidate_id)
      response = @client.get "/watchlist_candidates/#{watchlist_candidate_id}"
    end

    # GET https://api.blockscore.com/watchlist_candidates
    def all(count = nil, offset = nil, options = {})
      body = (options.include? :body) ? options[:body] : {}

      body[:count] = count
      body[:offset] = offset

      @client.get '/watchlist_candidates', body
    end

    # GET https://api.blockscore.com/watchlist_candidates/:id/history
    def history(watchlist_candidate_id)
      response = @client.get "/watchlist_candidates/#{watchlist_candidate_id}/history"
    end

    # GET https://api.blockscore.com/watchlist_candidates/:id/hits
    def hits(watchlist_candidate_id)
      response = @client.get "/watchlist_candidates/#{watchlist_candidate_id}/hits"
    end
  end
end