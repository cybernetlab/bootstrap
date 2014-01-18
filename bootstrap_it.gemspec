lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bootstrap_it/version'

Gem::Specification.new do |spec|
  spec.name          = 'bootstrap_it'
  spec.version       = BootstrapIt::VERSION
  spec.authors       = ['Alexey Ovchinnikov']
  spec.email         = ['alexey.ovchinnikov@yandex.ru']
  spec.description   = %q{Bootstrap wrapper for rails}
  spec.summary       = 'This package provides helpers for easly creating' \
                       'sites with <a href="http://getbootstrap.com">' \
                       'Twitter Bootstrap 3]</a> framework.'
  spec.homepage      = 'https://github.com/cybernetlab/bootstrap_it'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'rails', '~> 4.0.0'
  spec.add_dependency 'wrap_it'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'redcarpet', '~> 1.17'
  spec.add_development_dependency 'yard', '~> 0.7.5'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'combustion'
  spec.add_development_dependency 'capybara'
end
