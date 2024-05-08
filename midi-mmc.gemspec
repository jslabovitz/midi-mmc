Gem::Specification.new do |gem|
  gem.name          = 'midi-mmc'
  gem.version       = '0.1'
  gem.authors       = 'John Labovitz'
  gem.email         = 'johnl@johnlabovitz.com'
  gem.summary       = %q{Perform MIDI Machine Control (MMC)}
  gem.description   = %q{Perform MIDI Machine Control (MMC).}
  gem.homepage      = 'https://github.com/jslabovitz/midi-mmc.git'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'bundler', '~> 2.5'
  gem.add_development_dependency 'minitest', '~> 5.22'
  gem.add_development_dependency 'minitest-power_assert', '~> 0.3'
  gem.add_development_dependency 'rake', '~> 13.2'
end