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
    # http_body - The body of the HTTP request.
    # json_body - The JSON body of the HTTP request.
    # param - The parameter which was invalid.
    #
    # Examples
    #
    # begin
    #   response = BlockScore::Person.create(...)
    # rescue BlockScore::InvalidRequestError => e
    #   puts "ERROR: #{e.message} with code #{e.http_status}"
    # end
    def initialize(options = {})
      super
      @param = options.fetch :param, nil
    end
  end
end
