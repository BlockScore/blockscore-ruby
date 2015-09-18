require 'vcr'
require 'rspec'

module BlockScore
  VCR.configure do |c|
    c.cassette_library_dir = 'spec/cassettes'
    c.hook_into :webmock
    c.configure_rspec_metadata!
    c.ignore_hosts 'codeclimate.com'

    c.filter_sensitive_data('BLOCKSCORE_TEST_KEY') { ENV['BLOCKSCORE_TEST_KEY'] }
  end

  RSpec.configure do |config|
    config.before(:suite) do
      BlockScore.api_key = ENV.fetch('BLOCKSCORE_TEST_KEY', 'BLOCKSCORE_TEST_KEY')
    end

    config.around(:each) do |example|
      options = example.metadata[:vcr] || {
        record: (ENV['VCR_RECORD_MODE'] ? ENV['VCR_RECORD_MODE'].to_sym : :none)
      }

      if options[:record] == :skip
        VCR.turned_off(&example)
      else
        name = example.metadata[:full_description]
          .split(/\s+/, 2)
          .join('/')
          .underscore
          .gsub(/[.#?]/, '/')
          .gsub(%r(\/+), '/')
          .strip
          .tr(' ', '_')
          .gsub(%r([/_ ]$), '')

        VCR.use_cassette(name, options, &example)
      end
    end
  end
end
