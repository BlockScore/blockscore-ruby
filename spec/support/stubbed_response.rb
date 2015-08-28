module BlockScore
  # Stubbed response wrapper
  class StubbedResponse
    include FactoryGirl::Syntax::Methods

    def initialize(request)
      @request = request
    end

    def factory_name
      request.resource.singularize
    end

    private

    attr_reader :request

    # Response wrapper for history API calls
    class History < self
      def response
        {
          :status => 200,
          :body => factory_response,
          :headers => {}
        }
      end

      private

      def factory_response
        build_list(factory_name, count).to_json
      end
    end

    # Response wrapper for list API calls
    class List < self
      DEFAULT_COUNT_PARAMS = [5].freeze

      def response
        {
          :status => 200,
          :body => factory_response,
          :headers => {}
        }
      end

      private

      def factory_response
        {
          :total_count => count,
          :has_more => false,
          :object => 'list',
          :data => build_list(factory_name, count)
        }.to_json
      end

      def count
        request
          .query_params
          .fetch('count', DEFAULT_COUNT_PARAMS)
          .first
          .to_i
      end
    end

    # Response wrapper for retrieve API calls
    class Retrieve < self

      def response
        {
          status: 200,
          body: factory_response,
          headers: {}
        }
      end

      private

      def factory_response
        json(factory_name)
      end
    end

    # Response wrapper for create API calls
    class Create < self

      def response
        {
            status: 201,
            body: factory_response,
            headers: {}
        }
      end

      private

      def factory_response
        json(factory_name)
      end
    end

    # Response wrapper for error API calls
    class Error < self
      MAP = {
        '400' => :invalid_request_error,
        '401' => :authentication_error,
        '404' => :not_found_error,
        '500' => :api_error
      }

      def response
        {
          status: status.to_i,
          body: factory_response,
          headers: {}
        }
      end

      private

      def factory_response
        json(:blockscore_error, error_type: error_type)
      end

      def error_type
        MAP.fetch(status)
      end

      def status
        request.id
      end
    end

    # Module for defining how to route stubbed requests
    module Router
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

      route(Error)    { |stub| StubbedResponse::Error::MAP.key?(stub.id)               }
      route(Retrieve) { |stub| BlockScore::StubbedResponse::Error::MAP.key?(stub.id)   }
      route(Create)   { |stub| stub.http_method.equal?(:post) && !stub.has?(:action)   }
      route(Retrieve) { |stub| stub.http_method.equal?(:delete) && !stub.has?(:action) }
      route(List)     { |stub| !stub.has?(:id) && stub.http_method.equal?(:get)        }
      route(List)     { |stub| stub.action.eql?('hits')                                }
      route(History)  { |stub| stub.action.eql?('history')                             }
      route(Retrieve) { |stub| stub.action.eql?('score')                               }
      route(Retrieve) { |stub| stub.http_method.equal?(:patch)                         }
      route(Retrieve) { |stub| stub.has?(:id) && stub.http_method.equal?(:get)         }
    end
  end
end