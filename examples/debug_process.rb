#!/usr/bin/env ruby
# frozen_string_literal: true

require "open3"
require "json"
require "timeout"

puts "=== Debug Process Example ==="

cli_path = `which claude`.chomp
puts "CLI path: #{cli_path}"

args = ["--print", "--output-format", "stream-json", "--verbose", "What is 2 + 2?"]
puts "Command: #{cli_path} #{args.join(" ")}"

ENV["ANTHROPIC_API_KEY"] =
  "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"

stdin, stdout, stderr, wait_thread = Open3.popen3(cli_path, *args)

puts "\nProcess started, PID: #{wait_thread.pid}"

# Read stdout in a thread
stdout_thread = Thread.new do
  puts "\nSTDOUT:"
  stdout.each_line do |line|
    puts "  > #{line}"
  end
end

# Read stderr in a thread
stderr_thread = Thread.new do
  puts "\nSTDERR:"
  stderr.each_line do |line|
    puts "  ! #{line}"
  end
end

# Wait for threads with timeout
begin
  Timeout.timeout(5) do
    stdout_thread.join
    stderr_thread.join
  end
rescue Timeout::Error
  puts "\n[Timeout after 5 seconds]"
end

# Check process status
if wait_thread.alive?
  puts "\nProcess still alive, killing..."
  Process.kill("TERM", wait_thread.pid)
  wait_thread.join(1)
end

puts "\nExit status: #{wait_thread.value.exitstatus}"

stdin.close
stdout.close
stderr.close
