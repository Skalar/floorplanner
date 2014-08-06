# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'floorplanner/version'

Gem::Specification.new do |spec|
  spec.name          = "floorplanner"
  spec.version       = Floorplanner::VERSION
  spec.authors       = ["Thorbjørn Hermansen", "Peter Skeide"]
  spec.email         = ["thhermansen@gmail.com", "ps@skalar.no"]
  spec.description   = %q{Ruby interface for Floorplanner's REST API}
  spec.summary       = %q{Ruby interface for Floorplanner's REST API}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "httpi", "~> 2.2.5"
  spec.add_dependency "nokogiri", "~> 1.6.1"
  spec.add_dependency "nori", "~> 2.3.0"
  spec.add_dependency "gyoku", "~> 1.1.1"
  spec.add_dependency "hashie"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rake"
end
