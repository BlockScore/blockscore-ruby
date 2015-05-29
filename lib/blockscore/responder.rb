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

        dispatch_success(json_obj)
      else
        Util.handle_api_error response
      end
    end

    private

    def build_response_from_arr(arr_obj)
      arr_obj.map { |obj| Util.create_object(resource, obj) }
    end

    def dispatch_success(json)
      if watchlist_search?(json)
        Util.create_watchlist_hit_array json[:matches]
      elsif resource_array?(json)
        build_response_from_arr json
      elsif resource_index?(json)
        index_response(json)
      else # single object
        Util.create_object resource, json
      end
    end

    # candidates#search endpoint
    def watchlist_search?(data)
      data.respond_to?(:key?) && data.key?(:matches)
    end

    # hash style list format
    def resource_index?(data)
      data.class == Hash && data[:object] == 'list'
    end

    def index_response(json)
      data = json[:data]

      if data.first.class == Hash && data.first.key?(:matching_info)
        Util.create_watchlist_hit_array data
      else
        build_response_from_arr data
      end
    end

    # array formatted response
    def resource_array?(data)
      data.class == Array
    end
  end
end
