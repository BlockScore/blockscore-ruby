require 'blockscore/errors/error'

module BlockScore
  class InvalidRequestError < Error
    attr_accessor :param

    # Public: Creates a new instance of BlockScore::InvalidRequestError.
    #
    # rbody - The HTTP response body from HTTParty.
    # rcode - The HTTP response code from HTTParty.
    #
    # Examples
    #
    # begin
    #   response = BlockScore::Person.create(...)
    # rescue BlockScore::InvalidRequestError => e
    #   puts "ERROR: #{e.message} with code #{e.http_status}"
    # end
    def initialize(rbody, rcode = nil)
      super
      @param = rbody[:error][:param]
    end

    def to_s
      status_string = @http_status ? "" : "(Status: #{@http_status})"
      type_string = @error_type ? "" : "(Type: #{@error_type})"
      param_string = @param ? "" : "(Param: #{@param})"

      "#{type_string} #{param_string} #{message} #{status_string}"
    end
  end
end
