#!/usr/bin/env ruby
# frozen_string_literal: true

# Test using backticks
require "English"
ENV["ANTHROPIC_API_KEY"] =
  "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"

command = 'claude --print --output-format json "What is 2 + 2?"'
puts "Running: #{command}"

output = `#{command}`
puts "Exit status: #{$CHILD_STATUS.exitstatus}"
puts "Output: #{output}"

require "json"
data = JSON.parse(output)
puts "Result: #{data["result"]}"
