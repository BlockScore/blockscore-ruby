module BlockScore
  module Actions
    module Update     
      def save
        begin
          self.class.patch "#{self.class.endpoint}#{id}", filter_params
          true
        rescue
          false
        end
      end

      # Filters out the non-updateable params
      def filter_params
        persistent = %i(id object created_at updated_at livemode class)
        @attrs.reject { |k,v| persistent.include?(k) }
      end

      def method_missing(method, *args, &block)
        if respond_to_missing? method
          is_setter = method.to_s[-1] == '='
          if is_setter
            @attrs[method.to_s.chomp('=').to_sym] = args[0]
          else
            @attrs[method]
          end
        else
          super
        end
      end

      def respond_to_missing?(symbol, include_private = false)
        setter = symbol.to_s[0..-2].to_sym
        @attrs && (@attrs.has_key?(symbol) || @attrs.has_key?(setter)) || super
      end
    end
  end
end
