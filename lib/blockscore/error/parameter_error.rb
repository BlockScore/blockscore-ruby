require 'lib/blockscore/error/blockscore_error'

module BlockScore
  class ParameterError < BlockscoreError

    @@http_status = 400

    def initialize(message=nil, json_body=nil, error_type=nil)
      super(message, json_body, @@http_status, error_type)
    end
  end
end