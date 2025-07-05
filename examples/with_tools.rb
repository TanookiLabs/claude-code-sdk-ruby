#!/usr/bin/env ruby
# frozen_string_literal: true

# Add the lib directory to the load path for local development
$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "claude_code_sdk"

# Query with tool permissions
puts "=== Query with Tools Example ==="

options = ClaudeCodeSDK::Options.new(
  system_prompt: "You are a helpful coding assistant",
  allowed_tools: %w[read_file write_file list_files],
  max_thinking_tokens: 10_000,
  cwd: Dir.pwd
)

ClaudeCodeSDK.query("List the files in the current directory", options) do |message|
  case message
  when ClaudeCodeSDK::AssistantMessage
    message.content.each do |block|
      case block
      when ClaudeCodeSDK::Content::TextBlock
        puts block.text
      when ClaudeCodeSDK::Content::ToolUseBlock
        puts "[Tool Use] #{block.name}: #{block.input}"
      end
    end
  when ClaudeCodeSDK::SystemMessage
    puts "[System] #{message.title}"
  when ClaudeCodeSDK::ResultMessage
    puts "[Result] Status: #{message.status}"
    puts "  Cost: $#{message.cost[:usd]}" if message.cost
  end
end
