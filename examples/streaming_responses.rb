#!/usr/bin/env ruby
# frozen_string_literal: true

# Add the lib directory to the load path for local development
$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "claude_code_sdk"

# Example showing real-time streaming of responses
puts "=== Streaming Response Example ==="

# Configure global defaults
ClaudeCodeSDK.configure do |config|
  config.default_system_prompt = "You are a Ruby programming expert"
  config.default_cwd = Dir.pwd
end

# Track message types
message_counts = Hash.new(0)

ClaudeCodeSDK.query("Write a Ruby function to calculate fibonacci numbers") do |message|
  message_counts[message.class.name] += 1

  case message
  when ClaudeCodeSDK::UserMessage
    puts "\n[You] #{message.text}"
  when ClaudeCodeSDK::AssistantMessage
    print "\n[Claude] "
    message.content.each do |block|
      print block.text if block.is_a?(ClaudeCodeSDK::Content::TextBlock)
    end
  when ClaudeCodeSDK::SystemMessage
    puts "\n[System] #{message.title}: #{message.message}"
  when ClaudeCodeSDK::ResultMessage
    puts "\n\n[Conversation Complete]"
    puts "Status: #{message.status}"
    puts "Messages received:"
    message_counts.each { |type, count| puts "  #{type}: #{count}" }
  end
end
