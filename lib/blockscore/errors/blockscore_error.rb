module BlockScore
  class BlockScoreError < StandardError
    attr_reader :message
    attr_reader :http_status
    attr_reader :error_type
    attr_reader :http_body

    # Public: Creates a new instance of BlockScore::InvalidRequestError.
    #
    # Optional parameters:
    #
    # message - The String error message to report.
    # http_status - The Fixnum HTTP status code (usually 4xx or 5xx).
    # error_type - The type of error that occurred.
    # http_body - The body of the HTTP request.
    #
    # While BlockScoreError can be instantiated, the more meaningful
    # error classes are its subclasses:
    # InvalidRequestError - Indicates a malformed request (HTTP 400 or 404)
    # APIError - Indicates an error on the server side (HTTP 5xx)
    # AuthenticationError - Indicates an authentication error (HTTP 401)
    def initialize(response)
      @message = response[:error][:message]
      @http_status = response[:error][:code].to_i
      @error_type = response[:error][:type]
      @http_body = response
    end

    def to_s
      status_string = @http_status.nil? ? "" : "(Status #{@http_status})"
      "#{status_string} #{message}"
    end
  end
end
