module BlockScore
  class BlockScoreError < StandardError
    attr_reader :message
    attr_reader :http_status
    attr_reader :http_body
    attr_reader :json_body

    # Public: Creates a new instance of BlockScore::InvalidRequestError.
    #
    # Optional parameters:
    #
    # message - The String error message to report.
    # http_status - The Fixnum HTTP status code (usually 4xx or 5xx).
    # http_body - The body of the HTTP request.
    # json_body - The JSON body of the HTTP request.
    # param - The parameter which was invalid.
    #
    # While BlockScoreError can be instantiated, the more meaningful
    # error classes are its subclasses:
    # InvalidRequestError - Indicates a malformed request (HTTP 400 or 404)
    # APIError - Indicates an error on the server side (HTTP 5xx)
    # AuthenticationError - Indicates an authentication error (HTTP 401)
    def initialize(options = {})
      @message = options.fetch :message, nil
      @http_status = options.fetch :http_status, nil
      @http_body = options.fetch :http_body, nil
      @json_body = options.fetch :json_body, nil
    end

    def to_s
      status_string = @http_status.nil? ? "" : "(Status #{@http_status})"
      "#{status_string} #{message}"
    end
  end
end
