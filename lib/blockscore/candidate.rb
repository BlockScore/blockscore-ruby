module BlockScore
  class Candidate
    def initialize(client)
      @client = client
    end

    # POST https://api.blockscore.com/candidates
    def create(options = {})
      response = @client.post '/candidates', options
    end

    # PATCH https://api.blockscore.com/candidates/{CANDIDATE_ID}
    def edit(candidate_id, options = {})
      response = @client.put "/candidates/#{candidate_id}", options 
    end

    # DELETE https://api.blockscore.com/candidates/{CANDIDATE_ID}
    def delete(candidate_id)
      response = @client.delete "/candidates/#{candidate_id}"
    end

    # GET https://api.blockscore.com/candidates/{CANDIDATE_ID}
    def retrieve(candidate_id)
      response = @client.get "/candidates/#{candidate_id}"
    end

    # GET https://api.blockscore.com/candidates
    def all(count = nil, offset = nil, options = {})
      body = (options.include? :body) ? options[:body] : {}

      body[:count] = count
      body[:offset] = offset

      @client.get '/candidates', body
    end

    # GET https://api.blockscore.com/candidates/:id/history
    def history(candidate_id)
      response = @client.get "/candidates/#{candidate_id}/history"
    end

    # GET https://api.blockscore.com/candidates/:id/hits
    def hits(candidate_id)
      response = @client.get "/candidates/#{candidate_id}/hits"
    end
  end
end