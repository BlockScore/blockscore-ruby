module BlockScore
  module Util
    def self.parse_json!(json_obj)
      JSON.parse(json_obj, :symbolize_names => true)
    end

    def self.parse_json(json_obj)
      parse_json! json_obj
    rescue JSON::ParserError
      fail BlockScore::BlockScoreError, {
        :error => { :message =>
          "An error has occurred. If this problem persists, please message support@blockscore.com."
        }
      }
    end

    def self.create_object(resource, options = {})
      "BlockScore::#{resource.camelcase}".constantize.new(options)
    end

    def self.create_watchlist_hit(params)
      BlockScore::WatchlistHit.new(params)
    end

    def self.handle_api_error(rbody)
      obj = Util.parse_json(rbody)

      case obj[:code].to_i
      when 400, 404
        fail InvalidRequestError, obj
      when 401
        fail AuthenticationError, obj
      else
        fail APIError, obj
      end
    end
  end
end
