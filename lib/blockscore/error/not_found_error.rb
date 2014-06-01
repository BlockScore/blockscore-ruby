require_relative './blockscore_error'
module BlockScore
  class NotFoundError < BlockscoreError

    @@http_status = 404

    def initialize(message=nil, json_body=nil, error_type=nil)
      super(message, json_body, @@http_status, error_type)
    end
  end
end