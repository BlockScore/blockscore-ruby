module BlockScore
  module Response
    extend self

    def handle_response(resource, response)
      case response.code
      when 200, 201
        Dispatch.new(resource, response).call
      else
        api_error response
      end
    end

    private

    def api_error(response)
      obj = Util.parse_json(response.body)

      case response.code
      when 400, 404
        fail InvalidRequestError.new(obj, response.code)
      when 401
        fail AuthenticationError.new(obj, response.code)
      else
        fail APIError.new(obj, response.code)
      end
    end
  end
end
