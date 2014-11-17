module BlockScore
  class QuestionSet

    def initialize(client)
      @client = client
    end

    def create(people_id, options = {})
      body = (options.include? :body) ? options[:body] : {}
      body[:person_id] = people_id

      response = @client.post '/question_sets', body
    end

    # 
    # '/question_sets/:id/score' POST
    #
    # answers - 
    def score(id, answers)
      body = {}
      body[:answers] = answers

      response = @client.post "/question_sets/#{id.to_s}/score", body
    end

    # 
    # /question_sets/:id GET
    #
    # question_set_id -
    # people_id -
    def retrieve(id)
      body = Hash.new

      response = @client.get "/question_sets/#{id.to_s}", body
    end

    # 
    # '/question_sets' GET
    #
    def all(count = nil, offset = nil, options = {})
      body = (options.include? :body) ? options[:body] : {}

      body[:count] = count
      body[:offset] = offset

      @client.get '/question_sets', body
    end
  end
end