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
      fail error_class(response), response
    end

    def error_class(response)
      case response.code
      when 400 then
        InvalidRequestError
      when 401 then
        AuthenticationError
      when 404 then
        NotFoundError
      else
        APIError
      end
    end
  end
end
