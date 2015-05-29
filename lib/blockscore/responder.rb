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

    def dispatch_success(json)
      resource, data = parse(json)
      create_reponse_object resource, data
    end

    # Parses the data block out of the json object.
    def parse(json)
      if watchlist_search?(json)
        ['watchlist_hit', json[:matches]]
      elsif resource_index?(json)
        index_response(json)
      else
        [resource, json]
      end
    end

    def create_reponse_object(resource, data)
      method = builder(data)

      Util.send(method, resource, data)
    end

    def builder(data)
      if data.class == Array
        :create_array
      else
        :create_object
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
        ['watchlist_hit', data]
      else
        [resource, data]
      end
    end

    # array formatted response
    def resource_array?(data)
      data.class == Array
    end
  end
end
