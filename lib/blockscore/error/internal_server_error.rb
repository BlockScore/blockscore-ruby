require_relative './blockscore_error'
module BlockScore
  class InternalServerError < BlockscoreError

    @@http_status = 500

    def initialize(message=nil, json_body=nil, error_type=nil)

      super(message, json_body, @@http_status, error_type)

      @message = message
    end

    def to_s
      "Status: #{@@http_status}, Message: #{@message}"
    end
  end
end