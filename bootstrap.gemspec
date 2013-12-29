lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bootstrap/version'

Gem::Specification.new do |spec|
  spec.name          = 'bootstrap'
  spec.version       = Bootstrap::VERSION
  spec.authors       = ['Alexey Ovchinnikov']
  spec.email         = ['alexey.ovchinnikov@yandex.ru']
  spec.description   = %q{Bootstrap wrapper for rails}
  spec.summary       = %q{Bootstrap wrapper for rails}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'rails', '~> 4.0.0'

  spec.add_development_dependency 'bundler', '~> 1.3'
#  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'redcarpet', '~> 1.17'
  spec.add_development_dependency 'yard', '~> 0.7.5'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'combustion'
  spec.add_development_dependency 'capybara'
end
