# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'apill/version'

Gem::Specification.new do |gem|
  gem.rubygems_version  = '1.3.5'

  gem.name              = 'apill'
  gem.rubyforge_project = 'apill'

  gem.version           = Apill::VERSION
  gem.platform          = Gem::Platform::RUBY

  gem.authors           = %w{jfelchner}
  gem.email             = 'accounts+git@thekompanee.com'
  gem.date              = Time.now
  gem.homepage          = 'https://github.com/jfelchner/apill'

  gem.summary           = %q{Common API functionality}
  gem.description       = %q{}

  gem.rdoc_options      = ['--charset = UTF-8']
  gem.extra_rdoc_files  = %w{README.md LICENSE}

  gem.executables       = Dir['{bin}/**/*'].map {|dir| dir.gsub!(/\Abin\//, '')}
  gem.files             = Dir['{app,config,db,lib}/**/*'] + %w{Rakefile README.md}
  gem.test_files        = Dir['{test,spec,features}/**/*']
  gem.require_paths     = ['lib']

  gem.add_dependency              'human_error',    '~> 1.7'

  gem.add_development_dependency  'rspec',          '~> 3.0'
  gem.add_development_dependency  'rspectacular',   '~> 0.38'
end
