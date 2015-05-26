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

    def self.to_plural(str)
    end

    def self.to_constant(str)
      # candidate / candidates
      # person / people
      # company / companies
      # question_set / question_sets
    end

    def self.to_camelcase(str)
    end

    def self.to_underscore(str)
      str.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
    end
  end
end
