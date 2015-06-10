# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'blockscore/version'

Gem::Specification.new do |spec|
  spec.name        = 'blockscore'
  spec.version     = BlockScore::VERSION
  spec.authors     = ['Alain Meier', 'John Backus', 'Connor Jacobsen']
  spec.email       = ['alain@blockscore.com', 'john@blockscore.com']

  spec.summary     = 'A ruby client library for the BlockScore API.'
  spec.description = 'BlockScore makes ID verification easier and faster. See https://blockscore.com for more.'
  spec.homepage    = 'https://blockscore.com'
  spec.license     = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version  = '>= 1.9.3'

  spec.add_dependency('httparty', '~> 0.11')

  spec.add_development_dependency('shoulda', '~> 3.5', '>= 3.5.0')
  spec.add_development_dependency('rdoc', '~> 3.12')
  spec.add_development_dependency('bundler', '~> 1.0')
  spec.add_development_dependency('simplecov', '~> 0')
  spec.add_development_dependency('minitest', '~> 5.5')
  spec.add_development_dependency('webmock', '1.21')
  spec.add_development_dependency('faker', '1.4.3')
  spec.add_development_dependency('factory_girl', '4.1.0')
end
