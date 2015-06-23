module BlockScore
  class Fingerprint
    def initialize(resource, body)
      @resource = resource
      @body = Util.parse_json(body)
    end

    def data
      @data ||= begin
        if watchlist_search?
          body[:matches]
        elsif resource_index?
          body[:data]
        else
          body
        end
      end
    end

    def resource
      if watchlist_search? || watchlist_hits?
        'watchlist_hit'
      else
        @resource
      end
    end

    private

    attr_reader :body

    # candidates#search endpoint
    def watchlist_search?
      body.respond_to?(:key?) && body.key?(:matches)
    end

    # hash style list format
    def resource_index?
      body.is_a?(Hash) && body[:object] == 'list'
    end

    def watchlist_hits?
      data.first.is_a?(Hash) && data.first.key?(:matching_info)
    end
  end
end
