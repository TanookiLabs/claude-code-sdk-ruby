#!/usr/bin/env ruby
# frozen_string_literal: true

# Add the lib directory to the load path for local development
$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "claude_code_sdk"

# Enable debug output
puts "=== Debug Query Example ==="

# Create a simple transport to see what's happening
transport = ClaudeCodeSDK::Transport::SubprocessCLI.new(
  prompt: "What is 2 + 2?",
  options: ClaudeCodeSDK::Options.new
)

begin
  puts "Connecting to CLI..."
  transport.connect
  puts "Connected!"

  puts "\nReceiving messages..."
  transport.receive_messages do |raw_message|
    puts "Raw message: #{raw_message.inspect}"
  end
rescue StandardError => e
  puts "Error: #{e.class} - #{e.message}"
  puts e.backtrace.first(5).join("\n")
ensure
  puts "\nDisconnecting..."
  transport.disconnect
end

puts "Done!"
