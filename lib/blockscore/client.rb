module BlockScore
  class Client
    include HTTParty

    def initialize(api_key, version, options = {})
      @api_key = api_key
      @auth = { username: @api_key, password: "" }

      options[:base_uri] ||= "https://api.blockscore.com"
      options[:headers] = { 'Accept' => 'application/vnd.blockscore+json;version=' + version.to_s }
      
      options.each do |k,v|
        self.class.send k, v
      end
    end

    def get_verifications
      self.get '/verifications'
    end

    def get_verification(id)
      self.get '/verifications/' + id.to_s
    end

    def create_verification(options = {})
      self.post '/verifications/', options
    end

    def get_question_set(id)
      self.get '/questions/' + id.to_s
    end

    def create_question_set(options = {})
      self.post '/questions/', options
    end

    def score_question_set(options = {})
      self.post '/questions/score', options
    end

    def get(path, options = {})
      options = { body: options, basic_auth: @auth }
      puts options
      self.class.get(path, options)
    end

    def post(path, options = {})
      options = { body: options, basic_auth: @auth }
      self.class.post(path, options)
    end
  end
end