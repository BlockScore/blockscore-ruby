module BlockScore
  class QuestionSet

    def initialize(client)
      @client = client
    end

    def create(verification_id, options = {})
      body = (options.include? :body) ? options[:body] : {}
      body[:verification_id] = verification_id

      response = @client.post '/questions', body
    end

    # 
    # '/questions/:id/score' POST
    #
    # answers - 
    def score(id, answers)
    	body = {}
      body[:answers] = answers

			response = @client.post "/questions/#{id.to_s}/score", body
		end

		# 
		# /questions/:id GET
		#
		# question_set_id -
		# verification_id -
		def retrieve(id)
			body = Hash.new

			response = @client.get "/questions/#{id.to_s}", body
		end

		# 
		# '/questions' GET
		#
		def all(count = nil, offset = nil, options = {})
			body = (options.include? :body) ? options[:body] : {}

			body[:count] = count
			body[:offset] = offset

			@client.get '/questions', body
		end
	end
end