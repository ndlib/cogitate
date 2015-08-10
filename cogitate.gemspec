# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cogitate'

# Note: This is a namespace grab. I'm working on cogitate-client as well.
Gem::Specification.new do |spec|
  spec.name          = "cogitate"
  spec.version       = Cogitate::VERSION
  spec.authors       = ["Jeremy Friesen"]
  spec.email         = ["jeremy.n.friesen@gmail.com"]

  spec.summary       = %q{A client library for the Cogitate service.}
  spec.description   = %q{A client library for the Cogitate service.}
  spec.homepage      = "https://github.com/ndlib/cogitate"

  spec.files         = ['README.md', 'LICENSE', 'lib/cogitate.rb'] +
    `git ls-files -z lib/cogitate`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.license = 'APACHE2'

  spec.add_development_dependency "bundler", '~> 1.8'
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "rspec-its", "~> 1.2"
  spec.add_dependency "contracts", '~> 0.1'
end
