module BlockScore
  class Client
    include HTTParty

    attr_reader :people, :question_sets, :companies, :candidates, :watchlists

    def initialize(api_key, options = {})
      @api_key = api_key
      @auth = { :username => @api_key, :password => "" }
      @people = BlockScore::People.new(self)
      @question_set = BlockScore::QuestionSets.new(self)
      @companies = BlockScore::Companies.new(self)
      @candidate = BlockScore::Candidates.new(self)
      @watchlist = BlockScore::Watchlists.new(self)
      @error_handler = BlockScore::ErrorHandler.new

      options[:base_uri] ||= "https://api.blockscore.com"
      options[:headers] = { 'Accept' => 'application/vnd.blockscore+json;version=4' }
      
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