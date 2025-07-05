# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Testing
```bash
# Run all tests
bundle exec rake spec

# Run tests with coverage
bundle exec rake coverage

# Run integration tests (requires Claude Code CLI)
bundle exec rake integration

# Default task (runs spec + rubocop)
bundle exec rake
```

### Code Quality
```bash
# Run linter
bundle exec rubocop

# Generate documentation
bundle exec yard
```

### Development
```bash
# Install dependencies
bundle install

# Open console with gem loaded
bundle exec rake console

# Build and install gem locally
bundle exec rake install

# Release gem (updates version, creates tag, pushes to rubygems)
bundle exec rake release
```

## Architecture Overview

This is a Ruby SDK for Claude Code CLI that provides a Ruby interface to Anthropic's AI coding assistant. The architecture follows these key patterns:

### Core Structure
- **Main Entry Point**: `ClaudeCodeSDK` module provides `query()` and `ask()` methods
- **Transport Layer**: Abstracts communication with Claude Code CLI via subprocess
- **Message System**: Strongly typed message objects for different interaction types
- **Configuration**: Global and per-query configuration options

### Key Components

**Transport Layer** (`lib/claude_code_sdk/transport/`):
- `Base`: Abstract transport interface
- `SimpleCLI`: Current implementation using direct CLI execution
- `SubprocessCLI`: Alternative implementation (currently disabled due to subprocess issues)

**Message Types** (`lib/claude_code_sdk/messages.rb`):
- `UserMessage`: User input
- `AssistantMessage`: Claude's responses with content blocks (text, tool use, tool results)
- `SystemMessage`: System notifications
- `ResultMessage`: Session results with cost/usage data

**Configuration** (`lib/claude_code_sdk/configuration.rb`):
- Singleton pattern for global defaults
- Options object for per-query configuration
- Supports all Claude Code CLI parameters (tools, permissions, prompts, etc.)

### Transport Implementation Details
The SDK currently uses `SimpleCLI` transport which spawns the Claude Code CLI process for each query. The CLI communication happens via JSON message streaming, with the SDK parsing and converting CLI output into strongly-typed Ruby message objects.

### Prerequisites
- Ruby >= 3.0.0
- Claude Code CLI must be installed: `npm install -g @anthropic-ai/claude-code`
- Zeitwerk for autoloading

### Testing Strategy
- Unit tests for message parsing and configuration
- Integration tests that require actual Claude Code CLI
- Coverage reporting via SimpleCov
- RuboCop for code style enforcement