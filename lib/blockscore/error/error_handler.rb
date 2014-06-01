require 'json'
module BlockScore
  class ErrorHandler

    def initialize()
    end

    # Function:
    # check_error()
    #
    # response -
    #
    def check_error(response)

      @code = response.code
      @type = response.headers['content-type']

      if (200 <= @code and @code < 300)
        return response
      end

      @body = get_body(response)
      @message = get_message(@body)
      @error_type = @error_code = @param = nil

      # Internal API Error
      if @code == 500
        raise BlockScore::InternalServerError.new(@message, @body, @error_type)
      end

      if @body.include? 'error'
        @error = @body['error']
        @error_type = get_value(@error, 'type')
        @error_code = get_value(@error, 'code')
        @param = get_value(@error, 'param')
      end # body.include? 'error'

      process_code(@code)

    end # check_error


    # Function:
    # process_code()
    #
    # Tries to determine which error to raise.
    #
    # code -
    #
    def process_code(code)

      # Input data error
      if code == 400
        # Could not be validated.
        # Which type of input error?
        if @param
          raise BlockScore::ValidationError.new(@message, @body, @error_type, @param, @error_code)
        
        # Required parameter is missing
        else
          raise BlockScore::ParameterError.new(@message, @body, @error_type)
        end # if param
      
      # Error with an API Key
      elsif code == 401
        raise BlockScore::AuthorizationError.new(@message, @body, @error_type)
      
      # Trying to access nonexistent endpoint
      elsif code == 404
        raise BlockScore::NotFoundError.new(@message, @body, @error_type)

      # Generic BlockscoreError (fallback)
      else
        raise BlockScore::BlockscoreError.new(@message, @body)

      end # end code checking

    end # process code



    # Function:
    # get_body()
    #
    # response -
    #
    def get_body(response)
      type = response.headers['content-type']
      body = response.body

      # If response body is in JSON
      if type.include? 'json'
        body = JSON.parse(body)
      end # type.include?

      body
      
    end


    # Function:
    # get_message()
    #
    # body -
    #
    def get_message(body)
      message = ''
      if body.is_a? String
        message = body
      
      elsif body.is_a? Hash
        if body.include? 'error'
          message = body['error']['message']
        else
          message = 'Unable to select error message from json returned by request responsible for error'
        end # if body.include?
      else
        message = 'Unable to understand the content type of response returned by request responsible for error'
      end # if body.is_a? String

      message
    end # def get_message


    # Function:
    # get_value()
    #
    # obj -
    # key -
    #
    def get_value(obj, key)

      if obj.include? key
        return obj[key]
      end

      nil
    end

  end # class ErrorHandler
end # module BlockScore