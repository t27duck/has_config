# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'has_config/version'

Gem::Specification.new do |spec|
  spec.name          = 'has_config'
  spec.version       = HasConfig::VERSION
  spec.authors       = ['Tony Drake']
  spec.email         = ['t27duck@gmail.com']

  spec.summary       = 'Quick record-specific configuration for your models'
  spec.description   = <<-DESC
    Allows you to include and organize configuration options for each record in
    a model without the need of complex joins to settings tables or constantly
    adding random boolean and string columns
  DESC
  spec.homepage      = 'http://github.com/t27duck/has_config'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.6.0'
  spec.add_dependency 'activerecord', '>= 5.2.0'
  spec.add_dependency 'activesupport', '>= 5.2.0'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'pg'
end
