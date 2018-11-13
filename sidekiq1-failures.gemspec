# -*- encoding: utf-8 -*-
require File.expand_path('../lib/sidekiq1/failures/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Marcelo Silveira"]
  gem.email         = ["marcelo@mhfs.com.br"]
  gem.description   = %q{Keep track of Sidekiq failed jobs}
  gem.summary       = %q{Keeps track of Sidekiq failed jobs and adds a tab to the Web UI to let you browse them. Makes use of Sidekiq's custom tabs and middleware chain.}
  gem.homepage      = "https://github.com/mhfs/sidekiq1-failures/"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "sidekiq1-failures"
  gem.require_paths = ["lib"]
  gem.version       = Sidekiq1::Failures::VERSION

  gem.add_dependency "sidekiq1", ">= 4.0.0"

  gem.add_development_dependency "minitest"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rack-test"
  gem.add_development_dependency "sprockets"
  gem.add_development_dependency "sinatra"
end
