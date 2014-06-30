module BlockScore
  class Client
    include HTTParty

    @ssl_path = File.expand_path(File.join(File.dirname(__FILE__), '../blockscore-cert.crt'))
    ssl_ca_file @ssl_path

    attr_reader :verification, :question_set, :company

    def initialize(api_key, version, options = {})
      @api_key = api_key
      @auth = { :username => @api_key, :password => "" }
      @verification = BlockScore::Verification.new(self)
      @question_set = BlockScore::QuestionSet.new(self)
      @company = BlockScore::Company.new(self)
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

  end
end