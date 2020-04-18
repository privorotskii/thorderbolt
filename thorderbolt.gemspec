# frozen_string_literal: true

require_relative 'lib/thorderbolt/version'

Gem::Specification.new do |spec|
  spec.name          = 'thorderbolt'
  spec.version       = Thorderbolt::VERSION
  spec.authors       = ['Alexandr Privorotskiy']
  spec.email         = ['aleksandr.privorotskiy@gmail.com']

  spec.summary       = 'Active record custom ordering'
  spec.description   = %(
    This gem provide a possibility to order as specified
  )
  spec.homepage      = 'https://github.com/TolichP/thorderbolt'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/TolichP/thorderbolt'
  spec.metadata['changelog_uri'] = %(https://github.com/TolichP/thorderbolt/blob/master/CHANGELOG.md)

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activerecord'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.76'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'sqlite3'
end
