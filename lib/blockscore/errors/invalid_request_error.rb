require 'blockscore/errors/blockscore_error'

module BlockScore
  class InvalidRequestError < BlockScoreError
    attr_accessor :param

    # Public: Creates a new instance of BlockScore::InvalidRequestError.
    #
    # Optional parameters:
    #
    # message - The String error message to report.
    # http_status - The Fixnum HTTP status code (usually 4xx or 5xx).
    # error_type - The type of error that occurred.
    # http_body - The body of the HTTP request.
    # param - The parameter which was invalid.
    #
    # Examples
    #
    # begin
    #   response = BlockScore::Person.create(...)
    # rescue BlockScore::InvalidRequestError => e
    #   puts "ERROR: #{e.message} with code #{e.http_status}"
    # end
    def initialize(response, rcode = nil)
      super
      @param = response[:error][:param]
    end

    def to_s
      status_string = @http_status.nil? ? "" : "(Status: #{@http_status})"
      type_string = @error_type.nil? ? "" : "(Type: #{@error_type})"
      param_string = @param.nil? ? "" : "(Param: #{@param})"

      "#{type_string} #{param_string} #{message} #{status_string}"
    end
  end
end
