require 'codeclimate-test-reporter'
SimpleCov.start do
  add_filter '/spec/'

  formatter SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    CodeClimate::TestReporter::Formatter
  ]
end

require 'dotenv'
Dotenv.load

require 'blockscore'
require 'timeout'
require 'vcr_setup'
require 'factory_girl'
require 'webmock'
require 'webmock/rspec'
require 'rspec'
require 'rspec/its'

BlockScore::Spec.setup

module BlockScore
  RSpec.configure do |config|
    config.include(FactoryGirl::Syntax::Methods)

    config.expect_with :rspec do |expectations|
      expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    end

    config.mock_with :rspec do |mocks|
      mocks.verify_partial_doubles = true
    end

    config.filter_run :focus
    config.run_all_when_everything_filtered = true
    config.example_status_persistence_file_path = 'spec/.rspec-state'
    config.disable_monkey_patching!
    config.warnings = true

    config.default_formatter = 'doc' if config.files_to_run.one?

    config.profile_examples = 10

    config.order = :random
    Kernel.srand config.seed

    config.around do |example|
      Timeout.timeout(6, &example)
    end
  end
end
