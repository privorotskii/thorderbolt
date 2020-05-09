# frozen_string_literal: true

require_relative 'lib/thorderbolt/version'

Gem::Specification.new do |spec|
  spec.name          = 'thorderbolt'
  spec.version       = Thorderbolt::VERSION
  spec.authors       = ['Alexandr Privorotskiy']
  spec.email         = ['privorotskii@gmail.com']

  spec.summary       = 'Active record arbitrary ordering'
  spec.homepage      = 'https://github.com/privorotskii/thorderbolt'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/privorotskii/thorderbolt'
  spec.metadata['changelog_uri'] = %(https://github.com/privorotskii/thorderbolt/blob/master/CHANGELOG.md)

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activerecord', '>= 5.0'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'factory_bot', '~> 5.0'
  spec.add_development_dependency 'pry', '>= 0.12'
  spec.add_development_dependency 'pry-byebug', '~> 3.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.76'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.0'
  spec.add_development_dependency 'simplecov', '= 0.17.0'
  spec.add_development_dependency 'sqlite3', '~> 1.4.0'
end
