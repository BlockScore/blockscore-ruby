require 'blockscore/errors/api_error'
require 'blockscore/errors/authentication_error'
require 'blockscore/errors/blockscore_error'
require 'blockscore/errors/invalid_request_error'

module BlockScore
  module Responder
    def handle_response(response)
      case response.code
      when 200, 201
        json_obj = parse_json(response)

        if json_obj.class == Array
          build_response_from_arr json_obj
        elsif json_obj[:object] == 'list'
          build_response_from_arr json_obj[:data]
        else
          create_object(resource, json_obj)
        end
      else
        handle_api_error(response.code, response.body)
      end
    end

    private

    def parse_json(response)
      begin
        response = JSON.parse(response.body, :symbolize_names => true)
      rescue JSON::ParserError
        raise general_api_error(response.code.to_i, response.body)
      end
    end

    def build_response_from_arr(arr_obj)
      arr_obj.map { |obj| create_object(resource, obj) }
    end

    def create_object(resource, options = {})
      "BlockScore::#{resource.camelcase}".constantize.new(options)
    end

    def handle_api_error(rcode, rbody)
      begin
        error_obj = JSON.parse(rbody, :symbolize_names => true)
        error = error_obj[:error] or raise BlockScore::BlockScoreError.new

      rescue JSON::ParserError, BlockScore::BlockScoreError
        raise BlockScore::APIError, {
          :message => "Invalid response object: #{rbody.inspect} (HTTP #{rcode})",
          :http_code => rcode,
          :http_body => rbody
        }
      end

      case rcode
      when 400, 404
        # NEED MORE TESTS FOR THE ERRORS
        raise BlockScore::InvalidRequestError, {
          :message => error[:message],
          :param => error[:param],
          :http_code => rcode,
          :http_body => rbody,
          :json_body => error_obj
        }
      when 401
        # Usually due to an invalid API key.
        raise BlockScore::AuthenticationError, {
          :message => error[:message],
          :http_code => rcode,
          :http_body => rbody,
          :json_body => error_obj
        }
      else
        raise BlockScore::APIError, {
          :message => error[:message],
          :http_code => rcode,
          :http_body => rbody,
          :json_body => error_obj
        }
      end
    end
  end
end
