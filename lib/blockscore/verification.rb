module BlockScore
  class Verification

    def initialize(client)
      @client = client
    end

    # 
    # /verifications POST
    #
    def create(options = {})
      response = @client.post '/verifications', options
    end

    # 
    # /verifications/:id GET
    #
    # id -
    def retrieve(id, options = {})
      body = (options.include? :query) ? options[:body] : {}
      response = @client.get "/verifications/#{id.to_s}", body
    end

    # 
    # '/verifications' GET
    #
    def all(count = nil, offset = nil, options = {})
      body = (options.include? :body) ? options[:body] : {}

      body[:count] = count
      body[:offset] = offset

      @client.get '/verifications', body
    end
  end
end