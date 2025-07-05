#!/usr/bin/env ruby
# frozen_string_literal: true

# Add the lib directory to the load path for local development
$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "claude_code_sdk"

# Simple query with block
puts "=== Simple Query Example ==="
ClaudeCodeSDK.query("What is 2 + 2?") do |message|
  case message
  when ClaudeCodeSDK::AssistantMessage
    message.content.each do |block|
      puts block.text if block.is_a?(ClaudeCodeSDK::Content::TextBlock)
    end
  when ClaudeCodeSDK::SystemMessage
    puts "[System] #{message.title}: #{message.message}"
  end
end

puts "\n=== Using ask method ==="
response = ClaudeCodeSDK.ask("What is the capital of France?")
puts response
