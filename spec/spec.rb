# Consolidate spec setup and don't pollute global namespace
module BlockScore
  module Spec
    SPEC = File.expand_path('..', __FILE__).freeze

    IDENTIFIER = "blockscore-ruby/#{BlockScore::VERSION}".freeze
    HEADERS = {
      'Accept' => 'application/vnd.blockscore+json;version=4',
      'User-Agent' => %(#{IDENTIFIER} (https://github.com/BlockScore/blockscore-ruby)),
      'Content-Type' => 'application/json'
    }.freeze

    API_KEY = 'sk_test_a1ed66cc16a7cbc9f262f51869da31b3'.freeze

    WEBMOCK_WHITELIST = { allow: 'codeclimate.com' }.freeze

    STUB_PATTERN = %r(https://#{API_KEY}:@api\.blockscore\.com/*)

    module_function

    # Handle a webmock request
    #
    # @param request
    # @return [undefined]
    #
    # @api public
    def webmock_handler(request)
      request = BlockScore::StubbedRequest.new(request)
      BlockScore::StubbedResponse::Router.call(request).response
    end

    # Setup specs
    #
    # load in support directory helpers, init webmock, and init factory girl
    #
    # @return [undefined]
    #
    # @api public
    def setup
      load_support
      setup_webmock
      setup_factory_girl
    end

    def setup_webmock
      WebMock.disable_net_connect!(WEBMOCK_WHITELIST)
    end

    def setup_factory_girl
      FactoryGirl.reload
    end

    def load_support
      Dir[SPEC + '/support/**/*.rb'].each { |path| require(path) }
    end
  end
end
