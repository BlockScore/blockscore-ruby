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
      Util.to_constant("BlockScore::#{Util.to_camelcase(resource)}").new(options)
    end

    def self.create_watchlist_hit(params)
      BlockScore::WatchlistHit.new(params)
    end

    def self.handle_api_error(response)
      obj = Util.parse_json(response.body)

      case response.code
      when 400, 404
        fail InvalidRequestError, obj
      when 401
        fail AuthenticationError, obj
      else
        fail APIError, obj
      end
    end

    def self.to_plural(str)
      if str.end_with? 'y'
        str[0..-2] + 'ies'
      elsif str.end_with? 'h'
        str + 'es'
      elsif str == 'person'
        'people'
      else
        str + 's'
      end
    end

    def self.to_constant(camel_cased_word)
      names = camel_cased_word.split('::')

      # Trigger a built-in NameError exception including the ill-formed constant in the message.
      Object.const_get(camel_cased_word) if names.empty?

      # Remove the first blank element in case of '::ClassName' notation.
      names.shift if names.size > 1 && names.first.empty?

      names.inject(Object) do |constant, name|
        if constant == Object
          constant.const_get(name)
        else
          candidate = constant.const_get(name)
          next candidate if constant.const_defined?(name, false)
          next candidate unless Object.const_defined?(name)

          # Go down the ancestors to check if it is owned directly. The check
          # stops when we reach Object or the end of ancestors tree.
          constant = constant.ancestors.inject do |const, ancestor|
            break const    if ancestor == Object
            break ancestor if ancestor.const_defined?(name, false)
            const
          end

          # owner is in Object, so raise
          constant.const_get(name, false)
        end
      end
    end

    def self.to_camelcase(str)
      str.split('_').map { |i| i.capitalize }.join('')
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
