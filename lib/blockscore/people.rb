module BlockScore
  class People

    def initialize(client)
      @client = client
    end

    # 
    # /people POST
    #
    def create(options = {})
      response = @client.post '/people', options
    end

    # 
    # /people/:id GET
    #
    # id - ID of the person to retrieve.
    def retrieve(id, options = {})
      body = (options.include? :query) ? options[:body] : {}
      response = @client.get "/people/#{id.to_s}", body
    end

    # 
    # '/people' GET
    #
    def all(count = nil, offset = nil, options = {})
      body = (options.include? :body) ? options[:body] : {}

      body[:count] = count
      body[:offset] = offset

      @client.get '/people', body
    end
  end
end