module BlockScore
  class Error < StandardError
    attr_reader :message
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
    def initialize(rbody, rcode = nil)
      @message = rbody[:error][:message]
      @http_status = rcode
      @error_type = rbody[:error][:type]
      @http_body = rbody
    end

    def to_s
      status_string = @http_status.nil? ? "" : "(Status: #{@http_status})"
      type_string = @error_type.nil? ? "" : "(Type: #{@error_type})"

      "#{type_string} #{message} #{status_string}"
    end
  end
end
