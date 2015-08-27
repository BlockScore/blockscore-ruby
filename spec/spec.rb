# Consolidate spec setup and don't pollute global namespace
module BlockScore
  module Spec
    SPEC = File.expand_path('..', __FILE__).freeze
    HEADERS = {
      'Accept' => 'application/vnd.blockscore+json;version=4',
      'User-Agent' => 'blockscore-ruby/4.1.1 (https://github.com/BlockScore/blockscore-ruby)',
      'Content-Type' => 'application/json'
    }.freeze
    API_KEY = 'sk_test_a1ed66cc16a7cbc9f262f51869da31b3'.freeze
    WEBMOCK_WHITELIST = { allow: 'codeclimate.com' }.freeze

    module_function

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