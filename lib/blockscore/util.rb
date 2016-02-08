module BlockScore
  module Util
    extend self

    PLURAL_LOOKUP = {
      'candidate'     => 'candidates',
      'company'       => 'companies',
      'person'        => 'people',
      'question_set'  => 'question_sets',
      'watchlist_hit' => 'watchlist_hits'
    }

    PARSE_ERROR =
      'An error has occurred. ' \
        'If this problem persists, ' \
        'please message support@blockscore.com.'.freeze

    def parse_json!(json_obj)
      JSON.parse(json_obj, symbolize_names: true)
    end

    def parse_json(json_obj)
      parse_json! json_obj
    rescue JSON::ParserError
      raise Error, PARSE_ERROR
    end

    def create_object(resource, options = {})
      to_constant("BlockScore::#{to_camelcase(resource)}").new(options)
    end

    def create_array(resource, arr)
      arr.map { |obj| create_object(resource, obj) }
    end

    def to_plural(str)
      PLURAL_LOOKUP.fetch(str)
    end

    # Taken from activesupport: http://git.io/vkWtR
    def to_constant(camel_cased_word)
      names = camel_cased_word.split('::')

      # Trigger a built-in NameError exception including
      # the ill-formed constant in the message.
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

    def to_camelcase(str)
      str.split('_').map(&:capitalize).join
    end

    # Taken from Rulers: http://git.io/vkWqf
    def to_underscore(str)
      str.gsub(/::/, '/')
        .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
        .gsub(/([a-z\d])([A-Z])/, '\1_\2')
        .tr('-', '_')
        .downcase
    end
  end
end
