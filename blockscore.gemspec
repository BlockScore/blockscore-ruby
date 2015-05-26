# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'blockscore/version'

Gem::Specification.new do |spec|
  spec.name        = "blockscore"
  spec.version     = BlockScore::VERSION
  spec.authors     = ["Alain Meier", "John Backus", "Connor Jacobsen"]
  spec.email       = "alain@blockscore.com"

  spec.summary     = 'A ruby client library for the BlockScore API.'
  spec.description = 'A ruby client library for the BlockScore API.'
  spec.homepage    = 'http://docs.blockscore.com'
  spec.license     = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version  = '>= 1.9.3'

  spec.add_dependency(%q<httparty>, ["~> 0.11"])
  spec.add_development_dependency(%q<shoulda>, ["~> 3.5.0"])
  spec.add_development_dependency(%q<rdoc>, ["~> 3.12"])
  spec.add_development_dependency(%q<bundler>, ["~> 1.0"])
  spec.add_development_dependency(%q<simplecov>, [">= 0"])
  spec.add_development_dependency(%q<minitest>, ["~> 5.5"])
  spec.add_development_dependency(%q<webmock>, ["1.21"])
  spec.add_development_dependency(%q<faker>, ["1.4.3"])
  spec.add_development_dependency(%q<factory_girl>, ["4.1.0"])
end
