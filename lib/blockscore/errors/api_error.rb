module BlockScore
  class APIError < Error
    attr_reader :http_status
    attr_reader :error_type
    attr_reader :http_body

    # Public: Creates a new instance of BlockScore::Error.
    #
    # rbody - The HTTP response body from HTTParty.
    # rcode - The HTTP response code from HTTParty.
    #
    # While BlockScore::Error can be instantiated, the more meaningful
    # error classes are its subclasses:
    # InvalidRequestError - Indicates a malformed request (HTTP 400 or 404)
    # APIError - Indicates an error on the server side (HTTP 5xx)
    # AuthenticationError - Indicates an authentication error (HTTP 401)
    def initialize(response)
      body = JSON.parse(response.body, :symbolize_names => true)

      @message = body[:error][:message]
      @http_status = response.code
      @error_type = body[:error][:type]
      @http_body = body
    end

    def to_s
      status_string = @http_status ? "(Status: #{@http_status})" : ""
      type_string = @error_type ? "(Type: #{@error_type})" : ""

      "#{type_string} #{@message} #{status_string}"
    end
  end
end
