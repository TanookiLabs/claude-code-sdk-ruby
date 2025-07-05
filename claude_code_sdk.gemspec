# frozen_string_literal: true

require_relative "lib/claude_code_sdk/version"

Gem::Specification.new do |spec|
  spec.name = "claude_code_sdk"
  spec.version = ClaudeCodeSDK::VERSION
  spec.authors = ["Anthropic"]
  spec.email = ["sdk@anthropic.com"]

  spec.summary = "Ruby SDK for Claude Code"
  spec.description = "Official Ruby SDK for interacting with Claude Code - Anthropic's AI coding assistant"
  spec.homepage = "https://github.com/anthropics/claude-code-sdk-ruby"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata["documentation_uri"] = "https://www.rubydoc.info/gems/claude_code_sdk"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Files to include in the gem
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github Gemfile])
    end
  end

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Runtime dependencies
  spec.add_dependency "zeitwerk", "~> 2.6"

  # Development dependencies
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "pry", "~> 0.14"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.13"
  spec.add_development_dependency "rubocop", "~> 1.50"
  spec.add_development_dependency "rubocop-rake", "~> 0.6"
  spec.add_development_dependency "rubocop-rspec", "~> 2.20"
  spec.add_development_dependency "simplecov", "~> 0.22"
  spec.add_development_dependency "webmock", "~> 3.19"
  spec.add_development_dependency "yard", "~> 0.9"

  # Optional runtime dependencies
  spec.add_development_dependency "async", "~> 2.0" # For async support
  spec.add_development_dependency "sorbet-runtime", "~> 0.5" # For type checking
end
