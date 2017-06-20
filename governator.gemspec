# coding: utf-8

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

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday'
  spec.add_dependency 'twitter'
  spec.add_dependency 'nokogiri'

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
end
