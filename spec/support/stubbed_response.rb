module BlockScore
  class StubbedResponse
    class History
      include FactoryGirl::Syntax::Methods

      def initialize(factory_name)
        @factory_name = factory_name
      end

      def response
        {
          :status => 200,
          :body => factory_response,
          :headers => {}
        }
      end

      private

      attr_reader :factory_name

      def factory_response
        build_list(factory_name, count).to_json
      end
    end

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

      def initialize(request)
        @status = request.id
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

    class Router
      # When we do not match a route
      NoMatchError = Class.new(StandardError)
      REGISTRY = {} # Hash<Proc, Class>

      # Route a stubbed request
      #
      # @param stub [StubbedRequest]
      # @raise [NoMatchError] if we don't know how to route the request
      # @return response wrapper
      #
      # @api public
      def self.call(stub)
        route = match_route(stub) { fail NoMatchError, "Could not route #{stub.inspect}" }
        route.new(stub)
      end

      def self.match_route(stub, &no_match)
        _, matched = REGISTRY.detect(no_match) { |test, _| test.call(stub) }
        matched
      end

      # Define a route
      #
      # @param klass [Class] class to route to
      # @yield [StubbedRequest] stubbed request
      #
      # @return [undefined]
      #
      # @api private
      def self.route(klass, &block)
        fail ArgumentError, 'block required' unless block_given?
        fail ArgumentError, 'block should take one argument' unless block.arity.equal?(1)

        REGISTRY[block] = klass
      end
      private_class_method :route

      route(StubbedResponse::Error) { |stub| StubbedResponse::Error::MAP.key?(stub.id) }
    end
  end
end