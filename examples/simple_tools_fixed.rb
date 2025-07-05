#!/usr/bin/env ruby
# frozen_string_literal: true

# Add the lib directory to the load path for local development
$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "claude_code_sdk"

puts "=== Simple Tools Example (Fixed) ==="

# Create options without cwd to avoid CLI parsing issues
options = ClaudeCodeSDK::Options.new(
  allowed_tools: %w[read_file write_file list_files]
  # NOTE: Removing cwd for now as it causes CLI parsing issues
)

ClaudeCodeSDK.query("Help me understand what Ruby files are in this project", options) do |message|
  case message
  when ClaudeCodeSDK::AssistantMessage
    message.content.each do |block|
      case block
      when ClaudeCodeSDK::Content::TextBlock
        puts block.text
      when ClaudeCodeSDK::Content::ToolUseBlock
        puts "[Tool Use] #{block.name}: #{block.input.inspect}"
      end
    end
  when ClaudeCodeSDK::SystemMessage
    puts "[System] #{message.title}"
  when ClaudeCodeSDK::ResultMessage
    puts "[Result] Status: #{message.status}"
    puts "  Cost: $#{message.cost[:usd]}" if message.cost && message.cost[:usd]
  end
end
