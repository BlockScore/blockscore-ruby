module BlockScore
  class InvalidRequestError < APIError
    attr_accessor :param

    # Public: Creates a new instance of BlockScore::InvalidRequestError.
    #
    # responses - The HTTP response body from HTTParty.
    #
    # Examples
    #
    # begin
    #   response = BlockScore::Person.create(...)
    # rescue BlockScore::InvalidRequestError => e
    #   puts "ERROR: #{e.message} with code #{e.http_status}"
    # end
    def initialize(response)
      super
      @param = rbody[:error][:param]
    end

    def to_s
      status_string = @http_status ? "(Status: #{@http_status})" : ""
      type_string = @error_type ? "(Type: #{@error_type})" : ""
      param_string = @param ? "(#{@param})" : ""

      "#{type_string} #{@message} #{param_string} #{status_string}"
    end
  end
end
