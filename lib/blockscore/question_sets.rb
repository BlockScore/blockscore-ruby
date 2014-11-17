module BlockScore
  class QuestionSets
    PATH = '/question_sets'

    def initialize(client)
      @client = client
    end

    def create(person_id, options = {})
      body = (options.include? :body) ? options[:body] : {}
      body[:person_id] = person_id

      response = @client.post PATH, body
    end

    # 
    # '/question_sets/:id/score' POST
    #
    # answers - 
    def score(id, answers)
      body = {}
      body[:answers] = answers

      response = @client.post "#{PATH}/#{id.to_s}/score", body
    end

    # 
    # /question_sets/:id GET
    #
    # id -
    def retrieve(id)
      body = Hash.new

      response = @client.get "#{PATH}/#{id.to_s}", body
    end

    # 
    # '/question_sets' GET
    #
    def all(count = nil, offset = nil, options = {})
      body = (options.include? :body) ? options[:body] : {}

      body[:count] = count
      body[:offset] = offset

      @client.get PATH, body
    end
  end
end