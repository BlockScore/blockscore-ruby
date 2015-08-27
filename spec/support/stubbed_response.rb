module BlockScore
  class StubbedResponse
    class List
      include FactoryGirl::Syntax::Methods

      def initialize(factory_name, options)
        @factory_name = factory_name
        @count = options.fetch('count', [5]).first.to_i
      end

      def response
        {
          :status => 200,
          :body => factory_response,
          :headers => {}
        }
      end

      private

      attr_reader :factory_name, :count

      def factory_response
        {
          :total_count => count,
          :has_more => false,
          :object => 'list',
          :data => build_list(factory_name, count)
        }.to_json
      end
    end

    class Retrieve
      include FactoryGirl::Syntax::Methods

      def initialize(factory_name)
        @factory_name = factory_name
      end

      def response
        {
          status: 200,
          body: factory_response,
          headers: {}
        }
      end

      private

      attr_reader :factory_name

      def factory_response
        json(factory_name)
      end
    end

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