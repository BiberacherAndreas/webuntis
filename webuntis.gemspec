# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'webuntis/version'

Gem::Specification.new do |spec|
  spec.name          = "webuntis"
  spec.version       = WebUntis::VERSION
  spec.authors       = ["nilsding"]
  spec.email         = ["nilsding@nilsding.org"]
  spec.summary       = %q{Makes calls to the WebUntis API.}
  spec.description   = %q{This gem makes calls to the WebUntis JSON-RPC API.}
  spec.homepage      = "https://github.com/nilsding/webuntis"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
