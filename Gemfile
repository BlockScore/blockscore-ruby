source "https://rubygems.org"

gem 'httparty', '~> 0.11'

# Add dependencies to develop your gem here.
# Include everything needed to run rake, tests, features, etc.
group :development do
  gem 'rdoc', '~> 3.12'
  gem 'bundler', '~> 1.0'
  gem 'simplecov', '>= 0'
end

group :development, :test do
  gem 'test-unit', '~> 3.0'
  gem 'test-unit-activesupport', '~> 1.0'
  gem 'activesupport', '4.1.0.rc1'
  gem 'mutant', github: 'kbrock/mutant', branch: 'minitest'
  gem 'mutant-minitest', github: 'kbrock/mutant', branch: 'minitest'
  gem 'minitest', '~> 5.3'
end

group :test do
  gem 'webmock', '~> 1.21'
  gem 'factory_girl', '~> 4.1.0'
  gem 'faker', '~> 1.4.3'
end
