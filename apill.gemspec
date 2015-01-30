# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'apill/version'

Gem::Specification.new do |spec|
  spec.name          = 'apill'
  spec.version       = Apill::VERSION
  spec.authors       = ['jfelchner']
  spec.email         = 'accounts+git@thekompanee.com'
  spec.summary       = %q{Common API functionality}
  spec.description   = %q{}
  spec.homepage      = 'https://github.com/jfelchner/apill'
  spec.license       = 'MIT'

  spec.executables   = Dir['{bin}/**/*'].map    {|dir| dir.gsub!(/\Abin\//, '')}.
                                         reject {|bin| %w{rails rspec rake setup deploy}}
  spec.files         = Dir['{app,config,db,lib}/**/*'] + %w{Rakefile README.md LICENSE}
  spec.test_files    = Dir['{test,spec,features}/**/*']

  spec.add_dependency             'human_error',                ["~> 1.13"]
  spec.add_dependency             'kaminari',                   ["~> 0.16.2"]

  spec.add_development_dependency 'rspec',                      ["~> 3.0"]
  spec.add_development_dependency 'rspectacular',               ["~> 0.50"]
end
