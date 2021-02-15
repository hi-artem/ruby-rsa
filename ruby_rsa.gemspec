# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby_rsa/version'

Gem::Specification.new do |spec|
  spec.name          = 'ruby_rsa'
  spec.version       = RSA::VERSION
  spec.authors       = ['Artem Akatev']
  spec.email         = ['akatevone@gmail.com']
  spec.summary       = 'Pure-Ruby implementation of RSA'
  spec.description   = 'Pure-Ruby implementation of RSA. Hobby project and does not provide real cryptographic security.'
  spec.homepage      = 'https://github.com/hi-artem/ruby_rsa'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
end
