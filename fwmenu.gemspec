# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fwmenu/version'

Gem::Specification.new do |spec|
  spec.name          = "fwmenu"
  spec.version       = Fwmenu::VERSION
  spec.authors       = ["Brian"]
  spec.email         = ["brian@futureworkz.com"]

  spec.summary       = %q{Menu manager for Rails.}
  spec.description   = %q{Menu manager for Rails.}
  spec.homepage      = "TODO: https://github.com/brianfwz/fwmenu"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'https://github.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_dependency('enumerize')
  spec.add_dependency('friendly_id', '5.1.0')
  spec.add_dependency('slim-rails')
  spec.add_dependency('fwcontent', :git => 'https://github.com/brianfwz/fwcontent.git')
end
