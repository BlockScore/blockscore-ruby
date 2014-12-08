module BlockScore
  class BlockscoreError < StandardError

    attr_reader :message
    attr_reader :error_type
    attr_reader :http_status
    attr_reader :json_body

    def initialize(message=nil, json_body={}, http_status="400",
                    error_type="invalid_request_error")
      super(message)

      json_body["error"] ||= {}
      message_desc = "#{json_body["error"]["param"]} #{json_body["error"]["code"]}"

      @error_type = error_type 
      @http_status = http_status
      @json_body = json_body
      @message = "#{message} (#{message_desc})"
    end

    def to_s
      "Status: #{@http_status}. Type: #{@error_type}, Message: #{@message}"
    end

  end
end