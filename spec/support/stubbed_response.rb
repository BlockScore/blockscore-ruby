module BlockScore
  class StubbedResponse
    class Error
      include FactoryGirl::Syntax::Methods

      MAP = {
        '400' => :invalid_request_error,
        '401' => :authentication_error,
        '404' => :not_found_error,
        '500' => :api_error
      }

      def initialize(status)
        @status = status
      end

      def response
        {
          status: status.to_i,
          body: factory_response,
          headers: {}
        }
      end

      private

      attr_reader :status

      def factory_response
        json(:blockscore_error, error_type: error_type)
      end

      def error_type
        MAP.fetch(status)
      end
    end
  end
end