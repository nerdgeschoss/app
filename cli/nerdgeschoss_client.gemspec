# frozen_string_literal: true

require_relative "lib/nerdgeschoss_client/version"

Gem::Specification.new do |spec|
  spec.name = "nerdgeschoss_client"
  spec.version = NerdgeschossClient::VERSION
  spec.authors = ["Jens Ravens"]
  spec.email = ["jens@nerdgeschoss.de"]

  spec.summary = "Interact with the nerdgeschoss application from the command line"
  spec.homepage = "https://github.com/nerdgeschoss/app"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport"
  spec.add_dependency "netrc"
  spec.add_dependency "thor"
  spec.add_dependency "faraday"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
