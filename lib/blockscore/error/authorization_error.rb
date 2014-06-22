require File.join(File.dirname(__FILE__), 'blockscore_error')

module BlockScore
  class AuthorizationError < BlockscoreError

    @@http_status = 401

    def initialize(message=nil, json_body=nil, error_type=nil)

      super(message, json_body, @@http_status, error_type)
    end
  end
end