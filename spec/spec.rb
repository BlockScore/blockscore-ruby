# Consolidate spec setup and don't pollute global namespace
module BlockScore
  module Spec
    SPEC = File.expand_path('..', __FILE__).freeze

    module_function

    # Setup specs
    #
    # load in support directory helpers, init webmock, and init factory girl
    #
    # @return [undefined]
    #
    # @api public
    def setup
      load_support
      setup_factory_girl
    end

    def setup_factory_girl
      FactoryGirl.reload
    end

    def load_support
      Dir[SPEC + '/support/**/*.rb'].each { |path| require(path) }
    end
  end
end
