require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
end

require 'dotenv'
Dotenv.load

require 'blockscore'
require 'vcr'
require 'factory_girl'
require 'webmock'
require 'webmock/rspec'
require 'rspec'
require 'rspec/its'
require 'pry'

BlockScore::Spec.setup

module BlockScore
  VCR.configure do |c|
    c.cassette_library_dir = 'spec/cassettes'
    c.hook_into :webmock
    c.stub_with :webmock
    c.configure_rspec_metadata!
    c.ignore_hosts 'codeclimate.com'

    c.filter_sensitive_data('BLOCKSCORE_TEST_KEY') { ENV['BLOCKSCORE_TEST_KEY'] }
  end

  RSpec.configure do |config|
    config.include(FactoryGirl::Syntax::Methods)

    config.before(:suite) do
      BlockScore.api_key = ENV['BLOCKSCORE_TEST_KEY'] || 'BLOCKSCORE_TEST_KEY'
    end

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

    # Add VCR to all tests
    config.around(:each) do |example|
      options = example.metadata[:vcr] || { record: (ENV['VCR_RECORD_MODE'] ? ENV['VCR_RECORD_MODE'].to_sym : :none) }
      if options[:record] == :skip
        VCR.turned_off(&example)
      else
        name = example.metadata[:full_description].split(/\s+/, 2).join('/').underscore.gsub(/\./, '/').gsub(/[^\w\/]+/, '_').gsub(/\/$/, '')
        VCR.use_cassette(name, options, &example)
      end
    end
  end
end
