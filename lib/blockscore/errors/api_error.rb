require 'blockscore/errors/error'

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
      @http_body = JSON.parse(response.body, symbolize_names: true)

      @message = error_advice[:message]
      @http_status = response.code
      @error_type = error_advice[:type]
    end

    def to_s
      "#{type_string} #{@message} #{status_string}"
    end

    private

    def error_advice
      http_body.fetch(:error)
    end

    def type_string
      "(Type: #{error_type})" if error_type
    end

    def status_string
      "(Status: #{http_status})" if http_status
    end
  end
end
