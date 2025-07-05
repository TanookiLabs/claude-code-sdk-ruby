# Claude Code SDK for Ruby

Official Ruby SDK for interacting with Claude Code - Anthropic's AI coding assistant.

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

## Usage

### Simple Query

```ruby
require 'claude_code_sdk'

# Query with a block (streaming)
ClaudeCodeSDK.query("What is 2 + 2?") do |message|
  if message.is_a?(ClaudeCodeSDK::AssistantMessage)
    message.content.each do |block|
      puts block.text if block.is_a?(ClaudeCodeSDK::Content::TextBlock)
    end
  end
end

# Or use the ask method for simple text responses
response = ClaudeCodeSDK.ask("What is the capital of France?")
puts response  # => "The capital of France is Paris."
```

### With Options

```ruby
# Using a hash
ClaudeCodeSDK.query("Help me code",
  system_prompt: "You are a Ruby expert",
  allowed_tools: ["read_file", "write_file"],
  max_thinking_tokens: 10000
) do |message|
  # Handle messages
end

# Using Options object
options = ClaudeCodeSDK::Options.new(
  system_prompt: "You are a helpful assistant",
  allowed_tools: ["read_file", "write_file", "list_files"],
  cwd: "/path/to/project",
  permission_mode: ClaudeCodeSDK::PermissionMode::ACCEPT_EDITS
)

ClaudeCodeSDK.query("List files in the project", options) do |message|
  # Handle messages
end
```

### Global Configuration

```ruby
ClaudeCodeSDK.configure do |config|
  config.default_system_prompt = "You are a Ruby programming expert"
  config.default_cwd = "/home/user/projects"
  config.default_permission_mode = ClaudeCodeSDK::PermissionMode::DEFAULT
end
```

### Message Types

The SDK yields different message types during the conversation:

```ruby
ClaudeCodeSDK.query("Hello") do |message|
  case message
  when ClaudeCodeSDK::UserMessage
    puts "User: #{message.text}"
    
  when ClaudeCodeSDK::AssistantMessage
    message.content.each do |block|
      case block
      when ClaudeCodeSDK::Content::TextBlock
        puts "Claude: #{block.text}"
      when ClaudeCodeSDK::Content::ToolUseBlock
        puts "Tool: #{block.name} with #{block.input}"
      when ClaudeCodeSDK::Content::ToolResultBlock
        puts "Tool Result: #{block.output}"
      end
    end
    
  when ClaudeCodeSDK::SystemMessage
    puts "System: #{message.title} - #{message.message}"
    
  when ClaudeCodeSDK::ResultMessage
    puts "Status: #{message.status}"
    puts "Cost: $#{message.cost[:usd]}" if message.cost
  end
end
```

### Without Blocks

If you don't provide a block, `query` returns an array of all messages:

```ruby
messages = ClaudeCodeSDK.query("What is 2 + 2?")
messages.each do |message|
  puts message.inspect
end
```

## Options Reference

- `allowed_tools`: Array of tool names Claude can use
- `blocked_tools`: Array of tool names Claude cannot use
- `permission_mode`: How Claude handles file edits (`"default"`, `"acceptEdits"`, `"bypassPermissions"`)
- `max_thinking_tokens`: Maximum tokens for Claude's thinking process (default: 8000)
- `system_prompt`: System prompt to guide Claude's behavior
- `cwd`: Working directory for file operations
- `mcp_servers`: MCP server configurations
- `disable_cache`: Disable caching
- `no_markdown`: Disable markdown formatting
- `tree`: Array of paths to include in the file tree
- `tree_symlinks`: Include symlinks in file tree
- `tree_verbose`: Verbose file tree output

## Error Handling

```ruby
begin
  ClaudeCodeSDK.query("Hello") do |message|
    # Handle messages
  end
rescue ClaudeCodeSDK::CLINotFoundError => e
  puts "Claude Code CLI not found: #{e.message}"
rescue ClaudeCodeSDK::ProcessError => e
  puts "Process failed: #{e.message}"
  puts "Exit code: #{e.exit_code}"
  puts "Error output: #{e.stderr}"
rescue ClaudeCodeSDK::CLIJSONDecodeError => e
  puts "JSON parsing failed: #{e.message}"
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Testing

```bash
# Run all tests
bundle exec rake spec

# Run tests with coverage
bundle exec rake coverage

# Run integration tests (requires Claude Code CLI)
bundle exec rake integration

# Run linter
bundle exec rubocop
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/anthropics/claude-code-sdk-ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).