# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'governator/version'

Gem::Specification.new do |spec|
  spec.name          = 'governator'
  spec.version       = Governator::VERSION
  spec.authors       = ['M. Simon Borg']
  spec.email         = ['msimonborg@gmail.com']

  spec.summary       = 'Scraper for data on US Governors'
  spec.description   = 'Scraper for data on US Governors'
  spec.homepage      = 'https://github.com/msimonborg/governator'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z lib LICENSE.txt README.md governator.gemspec`.split("\0")
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.3'

  spec.add_dependency 'twitter', '~> 6.1.0'
  spec.add_dependency 'nokogiri', '~> 1.8.0'

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
end
