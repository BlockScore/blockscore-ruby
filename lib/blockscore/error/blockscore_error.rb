module BlockScore
	class BlockscoreError < StandardError

		attr_reader :message
		attr_reader :error_type
		attr_reader :http_status
		attr_reader :json_body

		def initialize(message=nil, json_body=nil, http_status="400",
				   	   	error_type="invalid_request_error")
			super(message)

			@message = message
			@error_type = error_type 
			@http_status = http_status
			@json_body = json_body

		end

		def to_s
			"Status: #{@http_status}. Type: #{@error_type}, Message: #{@message}"
		end

	end
end