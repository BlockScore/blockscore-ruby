require File.join(File.dirname(__FILE__), 'blockscore_error')

module BlockScore
  class ValidationError < BlockscoreError

    attr_reader :http_status
    attr_reader :error_code
    attr_reader :param

    @@http_status = 400

    def initialize(message=nil, json_body=nil,
                error_type=nil, param=nil, error_code=nil)

      super(message, json_body, @@http_status, error_type)

      @error_code = error_code
      @param = param

    end

    def to_s
      s = "Status: #{@@http_status}, Type: #{@error_type}, Param: #{@param}, "
      s += "Code: #{@error_code}, Message: #{@message}"
    end
    
  end
end