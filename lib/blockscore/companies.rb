module BlockScore
  class Companies

    def initialize(client)
      @client = client
    end

    # 
    # /companies POST
    #
    def create(options = {})
      response = @client.post '/companies', options
    end

    # 
    # /companies/:id GET
    #
    def retrieve(id, options = {})
      body = (options.include? :query) ? options[:body] : {}
      response = @client.get "/companies/#{id.to_s}", body
    end

    # 
    # '/companies' GET
    #
    def all(count = nil, offset = nil, options = {})
      body = (options.include? :body) ? options[:body] : {}

      body[:count] = count
      body[:offset] = offset

      @client.get '/companies', body
    end
  end
end