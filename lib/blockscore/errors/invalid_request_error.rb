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
      @param = error_advice[:param]
    end

    def to_s
      "#{type_string} #{@message} #{param_string} #{status_string}"
    end

    private

    def param_string
      "(#{param})" if param
    end
  end
end
