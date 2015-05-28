require 'blockscore/util'
require 'blockscore/errors/api_error'
require 'blockscore/errors/authentication_error'
require 'blockscore/errors/error'
require 'blockscore/errors/invalid_request_error'

module BlockScore
  module Responder
    def handle_response(response)
      case response.code
      when 200, 201
        json_obj = Util.parse_json(response.body)

        if json_obj.respond_to?(:key?) && json_obj.key?(:matches)
          json_obj[:matches].map { |obj| Util.create_watchlist_hit obj }
        elsif json_obj.class == Array
          build_response_from_arr json_obj
        elsif json_obj[:object] == 'list'
          data = json_obj[:data]
          
          if data.first.class == Hash && data.first.key?(:matching_info)
            data.map { |obj| Util.create_watchlist_hit(obj) }
          else
            build_response_from_arr data
          end
        else
          Util.create_object resource, json_obj
        end
      else
        Util.handle_api_error response
      end
    end

    private

    def build_response_from_arr(arr_obj)
      arr_obj.map { |obj| Util.create_object(resource, obj) }
    end
  end
end
