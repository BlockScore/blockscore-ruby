module BlockScore
  class Client
    include HTTParty

    attr_reader :verification, :question_set, :company, :watchlist_candidate

    def initialize(api_key, version, options = {})
      @api_key = api_key
      @auth = { :username => @api_key, :password => "" }
      @verification = BlockScore::Verification.new(self)
      @question_set = BlockScore::QuestionSet.new(self)
      @company = BlockScore::Company.new(self)
      @watchlist_candidate = BlockScore::WatchlistCandidate.new(self)
      @error_handler = BlockScore::ErrorHandler.new

      options[:base_uri] ||= "https://api.blockscore.com"
      options[:headers] = { 'Accept' => 'application/vnd.blockscore+json;version=' + version.to_s }
      
      options.each do |k,v|
        self.class.send k, v
      end
    end

    def get(path, options = {})
      options = { :body => options, :basic_auth => @auth }

      response = self.class.get(path, options)

      begin
        result = @error_handler.check_error(response)
      rescue BlockScore::BlockscoreError => e
        raise
      end

    end

    def post(path, options = {})
      options = { :body => options, :basic_auth => @auth }

      response = self.class.post(path, options)

      begin
        result = @error_handler.check_error(response)
      rescue BlockScore::BlockscoreError => e
        raise
      end

    end

    def put(path, options = {})
      options = { :body => options, :basic_auth => @auth }

      response = self.class.put(path, options)

      begin
        result = @error_handler.check_error(response)
      rescue BlockScore::BlockscoreError => e
        raise
      end

    end

    def delete(path, options = {})
      options = { :body => options, :basic_auth => @auth }

      response = self.class.delete(path, options)

      begin
        result = @error_handler.check_error(response)
      rescue BlockScore::BlockscoreError => e
        raise
      end

    end

  end
end