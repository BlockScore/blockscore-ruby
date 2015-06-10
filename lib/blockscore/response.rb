module BlockScore
  module Response
    extend self

    def handle_response(resource, response)
      case response.code
      when 200, 201
        Dispatch.new(resource, response).call
      else
        api_error(response)
      end
    end

    private

    def api_error(response)
      case response.code
      when 400
        fail InvalidRequestError.new(response)
      when 401
        fail AuthenticationError.new(response)
      when 404
        fail NotFoundError.new(response)
      else
        fail APIError.new(response)
      end
    end
  end
end
