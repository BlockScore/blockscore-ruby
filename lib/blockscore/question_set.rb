module BlockScore
  class QuestionSet

    def initialize(client)
      @client = client
    end

    def create(people_id, options = {})
      body = (options.include? :body) ? options[:body] : {}
      body[:verification_id] = people_id

      response = @client.post '/question_sets', body
    end

    # 
    # '/questions/:id/score' POST
    #
    # answers - 
    def score(id, answers)
    	body = {}
      body[:answers] = answers

			response = @client.post "/question_sets/#{id.to_s}/score", body
		end

		# 
		# /questions/:id GET
		#
		# question_set_id -
		# people_id -
		def retrieve(id)
			body = Hash.new

			response = @client.get "/question_sets/#{id.to_s}", body
		end

		# 
		# '/questions' GET
		#
		def all(count = nil, offset = nil, options = {})
			body = (options.include? :body) ? options[:body] : {}

			body[:count] = count
			body[:offset] = offset

			@client.get '/question_sets', body
		end
	end
end