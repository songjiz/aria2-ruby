# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aria2/version'

Gem::Specification.new do |spec|
  spec.name          = 'aria2'
  spec.version       = Aria2::VERSION
  spec.authors       = ['leky']
  spec.email         = ['lekyzsj@gmail.com']

  spec.summary       = %q{Aria2 JSON RPC client}
  spec.description   = %q{Aria2 JSON RPC client}
  spec.homepage      = 'https://github.com/leky'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
end
