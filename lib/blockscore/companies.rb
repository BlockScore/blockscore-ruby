module BlockScore
  class Companies
    PATH = '/companies'

    def initialize(client)
      @client = client
    end

    # 
    # /companies POST
    #
    def create(options = {})
      response = @client.post PATH, options
    end

    # 
    # /companies/:id GET
    #
    def retrieve(id, options = {})
      body = (options.include? :query) ? options[:body] : {}
      response = @client.get "#{PATH}/#{id.to_s}", body
    end

    # 
    # '/companies' GET
    #
    def all(count = nil, offset = nil, options = {})
      body = (options.include? :body) ? options[:body] : {}

      body[:count] = count
      body[:offset] = offset

      @client.get PATH, body
    end
  end
end