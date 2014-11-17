module BlockScore
  class People
    PATH = '/people'

    def initialize(client)
      @client = client
    end

    # 
    # /people POST
    #
    def create(options = {})
      response = @client.post PATH, options
    end

    # 
    # /people/:id GET
    #
    # id - ID of the person to retrieve.
    def retrieve(id, options = {})
      body = (options.include? :query) ? options[:body] : {}
      response = @client.get "#{PATH}/#{id.to_s}", body
    end

    # 
    # '/people' GET
    #
    def all(count = nil, offset = nil, options = {})
      body = (options.include? :body) ? options[:body] : {}

      body[:count] = count
      body[:offset] = offset

      @client.get PATH, body
    end
  end
end