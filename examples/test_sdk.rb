#!/usr/bin/env ruby
# frozen_string_literal: true

# Add the lib directory to the load path for local development
$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "claude_code_sdk"

puts "=== Testing Ruby SDK ==="
puts "SDK Version: #{ClaudeCodeSDK::VERSION}"
puts "Environment: #{ENV.fetch("CLAUDE_CODE_SDK", nil)}"

# Test Options creation
options = ClaudeCodeSDK::Options.new(
  system_prompt: "Test prompt",
  allowed_tools: %w[read_file write_file],
  max_thinking_tokens: 5000,
  cwd: "/tmp"
)

puts "\nOptions created successfully:"
puts "  System prompt: #{options.system_prompt}"
puts "  Allowed tools: #{options.allowed_tools.join(", ")}"
puts "  Max thinking tokens: #{options.max_thinking_tokens}"
puts "  CWD: #{options.cwd}"

puts "\nCLI args: #{options.to_cli_args.join(" ")}"

# Test message creation
user_msg = ClaudeCodeSDK::UserMessage.new(id: "1", text: "Hello")
puts "\nUser message created: #{user_msg.text}"

assistant_msg = ClaudeCodeSDK::AssistantMessage.new(
  id: "2",
  content: [
    ClaudeCodeSDK::Content::TextBlock.new(text: "Hi there!"),
    ClaudeCodeSDK::Content::ToolUseBlock.new(id: "tool1", name: "read_file", input: { path: "test.txt" })
  ]
)
puts "Assistant message created with #{assistant_msg.content.length} content blocks"

# Test error creation
error = ClaudeCodeSDK::CLINotFoundError.new("Test error", cli_path: "/usr/bin/claude")
puts "\nError created: #{error.message}"

puts "\n✅ Ruby SDK is working correctly!"
