# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2025-01-10

### Added
- Initial release of Claude Code SDK for Ruby
- Complete port of the official Python SDK functionality
- Support for all Claude Code CLI features including:
  - File operations (read, write, list)
  - Code generation and refactoring
  - Interactive development with streaming responses
  - Tool permissions and restrictions
  - System prompts and configuration
- Strongly typed message system with content blocks
- Global and per-query configuration options
- Comprehensive error handling
- Full test suite with RSpec
- Integration tests for CLI interaction
- Support for Ruby 3.0 and above

### Developer Experience
- Ruby idiomatic API with block-based iteration
- Flexible configuration with sensible defaults
- Detailed documentation and examples
- RuboCop style enforcement
- YARD documentation support

[Unreleased]: https://github.com/TanookiLabs/claude-code-sdk-ruby/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/TanookiLabs/claude-code-sdk-ruby/releases/tag/v0.1.0