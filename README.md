# Claude Code SDK for Ruby

[![Gem Version](https://badge.fury.io/rb/claude_code_sdk.svg)](https://badge.fury.io/rb/claude_code_sdk)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Ruby](https://img.shields.io/badge/ruby-%3E%3D%203.0.0-ruby.svg)](https://www.ruby-lang.org)

A Ruby port of the official Python SDK for Claude Code, providing a clean, idiomatic Ruby interface for interacting with Anthropic's Claude Code AI assistant. This gem enables Ruby developers to harness the power of Claude's advanced AI capabilities for code generation, refactoring, debugging, and more.

## Why Claude Code SDK for Ruby?

- **Fully Featured**: Complete port of the official Python SDK with all the same functionality
- **Ruby Idiomatic**: Designed with Ruby best practices in mind - blocks, enumerables, and familiar patterns
- **Real-time Streaming**: Process Claude's responses as they arrive for a responsive experience
- **Type-Safe Messages**: Strongly typed message objects for better code clarity and error prevention
- **Flexible Configuration**: Global defaults with per-query overrides
- **Comprehensive Tool Support**: Access to all Claude Code tools including file operations, search, and more
- **Production Ready**: Robust error handling, comprehensive test coverage, and battle-tested implementation

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'claude_code_sdk'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install claude_code_sdk

## Prerequisites

The SDK requires the Claude Code CLI to be installed:

```bash
npm install -g @anthropic-ai/claude-code
```

Make sure you have your Anthropic API key configured:

```bash
export ANTHROPIC_API_KEY="your-api-key"
```

## Quick Start

```ruby
require 'claude_code_sdk'

# Simple question
response = ClaudeCodeSDK.ask("What's the best way to implement a singleton in Ruby?")
puts response

# Code generation with streaming
ClaudeCodeSDK.query("Create a Ruby class for managing a todo list") do |message|
  if message.is_a?(ClaudeCodeSDK::AssistantMessage)
    message.content.each do |block|
      print block.text if block.is_a?(ClaudeCodeSDK::Content::TextBlock)
    end
  end
end
```

## Key Features

### 1. Code Generation and Refactoring

```ruby
# Generate code with specific requirements
ClaudeCodeSDK.query(
  "Create a thread-safe cache implementation with TTL support",
  system_prompt: "You are an expert Ruby developer focused on performance and thread safety"
) do |message|
  # Handle streaming responses
end

# Refactor existing code
code = File.read("legacy_code.rb")
ClaudeCodeSDK.ask("Refactor this code to use modern Ruby patterns:\n\n#{code}")
```

### 2. File Operations

```ruby
# Allow Claude to read and modify files
ClaudeCodeSDK.query(
  "Update all test files to use RSpec 3 syntax",
  allowed_tools: ["read_file", "write_file", "list_files"],
  cwd: Rails.root.to_s
) do |message|
  # Claude will analyze and update your test files
end
```

### 3. Code Analysis and Debugging

```ruby
# Analyze code for potential issues
ClaudeCodeSDK.query(
  "Analyze this Rails controller for security vulnerabilities and performance issues",
  allowed_tools: ["read_file"],
  tree: ["app/controllers"],
  tree_verbose: true
) do |message|
  # Get detailed analysis with file context
end
```

### 4. Interactive Development

```ruby
# Build features interactively
options = ClaudeCodeSDK::Options.new(
  allowed_tools: ["read_file", "write_file", "bash"],
  permission_mode: ClaudeCodeSDK::PermissionMode::ACCEPT_EDITS,
  max_thinking_tokens: 20000
)

ClaudeCodeSDK.query("Help me add user authentication to my Sinatra app", options) do |message|
  case message
  when ClaudeCodeSDK::AssistantMessage
    # Claude's responses and actions
  when ClaudeCodeSDK::SystemMessage
    puts "[System] #{message.title}: #{message.message}"
  when ClaudeCodeSDK::ResultMessage
    puts "Task completed! Cost: $#{message.cost[:usd]}"
  end
end
```

## Advanced Usage

### Global Configuration

```ruby
ClaudeCodeSDK.configure do |config|
  config.default_system_prompt = "You are a Ruby on Rails expert"
  config.default_cwd = Rails.root.to_s
  config.default_permission_mode = ClaudeCodeSDK::PermissionMode::DEFAULT
  config.default_allowed_tools = ["read_file", "list_files"]
end
```

### Working with Message Types

```ruby
ClaudeCodeSDK.query("Build a REST API endpoint") do |message|
  case message
  when ClaudeCodeSDK::UserMessage
    # Your input to Claude
    
  when ClaudeCodeSDK::AssistantMessage
    message.content.each do |block|
      case block
      when ClaudeCodeSDK::Content::TextBlock
        # Claude's text responses
        puts block.text
        
      when ClaudeCodeSDK::Content::ToolUseBlock
        # Claude using a tool
        puts "Using tool: #{block.name}"
        
      when ClaudeCodeSDK::Content::ToolResultBlock
        # Results from tool execution
        puts "Tool output: #{block.output}"
      end
    end
    
  when ClaudeCodeSDK::SystemMessage
    # System notifications
    
  when ClaudeCodeSDK::ResultMessage
    # Final results with usage stats
    puts "Tokens used: #{message.usage[:total_tokens]}"
  end
end
```

### Error Handling

```ruby
begin
  ClaudeCodeSDK.query("Complex task") do |message|
    # Handle messages
  end
rescue ClaudeCodeSDK::CLINotFoundError => e
  # Claude Code CLI not installed
rescue ClaudeCodeSDK::ProcessError => e
  # Process execution failed
  puts "Exit code: #{e.exit_code}"
  puts "Error: #{e.stderr}"
rescue ClaudeCodeSDK::TimeoutError => e
  # Operation timed out
rescue ClaudeCodeSDK::CLIJSONDecodeError => e
  # Invalid response from CLI
end
```

## Options Reference

| Option | Type | Description |
|--------|------|-------------|
| `allowed_tools` | Array | Tools Claude can use (e.g., `["read_file", "write_file"]`) |
| `blocked_tools` | Array | Tools Claude cannot use |
| `permission_mode` | String | File edit handling: `"default"`, `"acceptEdits"`, `"bypassPermissions"` |
| `max_thinking_tokens` | Integer | Max tokens for Claude's reasoning (default: 8000) |
| `system_prompt` | String | System instructions for Claude |
| `cwd` | String | Working directory for file operations |
| `mcp_servers` | Array | MCP server configurations |
| `disable_cache` | Boolean | Disable response caching |
| `no_markdown` | Boolean | Disable markdown formatting |
| `tree` | Array | Paths to include in file tree context |
| `tree_symlinks` | Boolean | Include symlinks in file tree |
| `tree_verbose` | Boolean | Verbose file tree output |

## Real-World Examples

### Rails Development Assistant

```ruby
# Help with Rails development tasks
ClaudeCodeSDK.query(
  "Add a full-text search feature to the Product model using PostgreSQL",
  allowed_tools: ["read_file", "write_file", "bash"],
  cwd: Rails.root.to_s,
  system_prompt: "You are a Rails expert. Follow Rails conventions and best practices."
) do |message|
  # Claude will analyze your models, create migrations, and implement search
end
```

### Test Generation

```ruby
# Generate comprehensive tests
ClaudeCodeSDK.query(
  "Generate RSpec tests for the UserService class with full coverage",
  allowed_tools: ["read_file", "write_file"],
  tree: ["app/services", "spec"]
) do |message|
  # Claude analyzes your code and creates thorough test suites
end
```

### Code Review Assistant

```ruby
# Automated code review
changed_files = `git diff --name-only main`.split("\n")
ClaudeCodeSDK.query(
  "Review these changed files for code quality, potential bugs, and improvements",
  allowed_tools: ["read_file"],
  tree: changed_files
) do |message|
  # Get detailed code review feedback
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests.

```bash
# Run all tests
bundle exec rake spec

# Run tests with coverage
bundle exec rake coverage

# Run integration tests (requires Claude Code CLI)
bundle exec rake integration

# Run linter
bundle exec rubocop

# Open console for experimentation
bundle exec rake console
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/TanookiLabs/claude-code-sdk-ruby. This project is intended to be a safe, welcoming space for collaboration.

1. Fork it
2. Create your feature branch (`git checkout -b feature/my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin feature/my-new-feature`)
5. Create a new Pull Request

## About Tanooki Labs

Claude Code SDK for Ruby is maintained by [Tanooki Labs LLC](https://tanookilabs.com), a software consultancy specializing in AI-powered developer tools and Ruby applications.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Acknowledgments

This gem is a Ruby port of the official Python SDK for Claude Code. We thank Anthropic for creating Claude and the Claude Code CLI that makes this integration possible.