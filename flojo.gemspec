# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'flojo/version'

Gem::Specification.new do |gem|
  gem.name          = "flojo"
  gem.version       = Flojo::VERSION
  gem.authors       = ["Altern Egro"]
  gem.email         = ["alternegro@me.com"]
  gem.description   = 'AR aware workflow'
  gem.summary       = 'AR aware workflow'
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
