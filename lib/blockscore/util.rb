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
  end
end
