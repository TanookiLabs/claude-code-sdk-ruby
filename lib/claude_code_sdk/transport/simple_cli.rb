# frozen_string_literal: true

require "English"
require "json"
require "shellwords"

module ClaudeCodeSDK
  module Transport
    class SimpleCLI < Base
      def initialize(prompt:, options: nil)
        @prompt = prompt
        @options = options || Options.new
        @connected = false
      end

      def connect
        @connected = true
      end

      def disconnect
        @connected = false
      end

      def connected?
        @connected
      end

      def receive_messages
        cli_path = find_cli_path
        raise CLINotFoundError.new(cli_path: cli_path) unless cli_path

        args = @options.to_cli_args
        args.push(@prompt)

        command = "#{cli_path} #{args.map { |arg| Shellwords.escape(arg) }.join(" ")}"
        puts "[DEBUG] Command: #{command}" if ENV["DEBUG"]

        # Set environment variable
        env = { "ANTHROPIC_API_KEY" => ENV.fetch("ANTHROPIC_API_KEY", nil) }

        # Run command and capture output
        output = IO.popen(env, command, "r", &:read)
        exit_status = $CHILD_STATUS.exitstatus

        puts "[DEBUG] Exit status: #{exit_status}" if ENV["DEBUG"]
        puts "[DEBUG] Output: #{output}" if ENV["DEBUG"]

        # Check for errors
        unless $CHILD_STATUS.success?
          raise ProcessError.new(
            "Claude Code process failed",
            exit_code: exit_status,
            stderr: output
          )
        end

        # Parse the JSON response
        begin
          data = JSON.parse(output, symbolize_names: true)

          # The response is a single result object, but we need to yield messages
          if data[:type] == "result" && data[:result]
            # Yield a user message with the prompt
            yield({ type: "user", text: @prompt })

            # Yield an assistant message with the response
            yield({
              type: "assistant",
              message: {
                id: "msg-#{data[:session_id]}",
                content: [{ type: "text", text: data[:result] }]
              }
            })

            # Yield the result message
            yield data
          end
        rescue JSON::ParserError
          raise CLIJSONDecodeError.new(
            "Failed to parse JSON from Claude Code",
            line: output
          )
        end
      end

      private

      def find_cli_path
        # Check if claude-code or claude is in PATH
        %w[claude-code claude].each do |name|
          path = `which #{name} 2>/dev/null`.chomp
          return path unless path.empty?
        end

        # Check common installation locations
        common_paths = [
          File.expand_path("~/bin/claude-code"),
          File.expand_path("~/bin/claude"),
          "/usr/local/bin/claude-code",
          "/usr/local/bin/claude",
          "/opt/claude-code/bin/claude-code"
        ]

        common_paths.find { |p| File.executable?(p) }
      end
    end
  end
end
