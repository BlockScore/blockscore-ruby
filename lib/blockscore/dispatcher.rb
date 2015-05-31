require 'blockscore/util'

module BlockScore
  class Dispatcher
    def initialize(resource, response)
      @resource = resource
      @response = response
      @json = Util.parse_json(response.body)
    end

    def call
      Util.send(builder, resource, data)
    end

    private

    attr_reader :json

    def data
      if watchlist_search?
        json[:matches]
      elsif resource_index?
        json[:data]
      else
        json
      end
    end

    def resource
      if watchlist_search? || watchlist_hits?
        'watchlist_hit'
      else
        @resource
      end
    end

    def builder
      resource_array? ? :create_array : :create_object
    end

    # candidates#search endpoint
    def watchlist_search?
      json.respond_to?(:key?) && json.key?(:matches)
    end

    # hash style list format
    def resource_index?
      json.is_a?(Hash) && json[:object] == 'list'
    end

    # array formatted response
    def resource_array?
      data.is_a? Array
    end

    def watchlist_hits?
      data.first.is_a?(Hash) && data.first.key?(:matching_info)
    end
  end
end
