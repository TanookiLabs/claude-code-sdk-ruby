# frozen_string_literal: true

require "open3"
require "json"
require "stringio"

module ClaudeCodeSDK
  module Transport
    class SubprocessCLI < Base
      BUFFER_SIZE = 1024 * 1024 # 1MB
      STDERR_TIMEOUT = 5 # seconds

      def initialize(prompt:, options: nil)
        @prompt = prompt
        @options = options || Options.new
        @process = nil
        @stdin = nil
        @stdout = nil
        @stderr = nil
        @wait_thread = nil
      end

      def connect
        return if @connected

        cli_path = find_cli_path
        raise CLINotFoundError.new(cli_path: cli_path) unless cli_path

        args = @options.to_cli_args
        args.push("--print", @prompt) # Add prompt after --print

        command = [cli_path] + args
        puts "[DEBUG] Command: #{command.join(" ")}" if ENV["DEBUG"]

        env = { "ANTHROPIC_API_KEY" => ENV.fetch("ANTHROPIC_API_KEY", nil) }
        env["CLAUDE_CODE_ENTRYPOINT"] = "sdk-ruby"

        popen_options = { chdir: @options.cwd }.compact
        @stdin, @stdout, @stderr, @wait_thread = Open3.popen3(env, *command, **popen_options)
        @stdin.close # Close stdin since we pass all data via args
        @connected = true
      rescue Errno::ENOENT
        raise CLINotFoundError.new("Claude Code CLI not found", cli_path: cli_path)
      end

      def disconnect
        return unless @connected

        @stdin&.close unless @stdin&.closed?
        @stdout&.close unless @stdout&.closed?
        @stderr&.close unless @stderr&.closed?

        if @wait_thread&.alive?
          begin
            Process.kill("TERM", @wait_thread.pid)
            @wait_thread.join(5)
          rescue Errno::ESRCH
            # Process already finished
          end
        end

        @process = nil
        @connected = false
      end

      def connected?
        @connected && @wait_thread&.alive?
      rescue Errno::ESRCH
        false
      end

      def receive_messages
        connect unless @connected

        json_buffer = ""

        # Read streaming JSON from stdout
        puts "[DEBUG] Reading streaming JSON..." if ENV["DEBUG"]

        begin
          @stdout.each_line do |line|
            line_str = line.strip
            next if line_str.empty?

            puts "[DEBUG] Read line: #{line_str}" if ENV["DEBUG"]

            json_buffer += line_str

            begin
              data = JSON.parse(json_buffer, symbolize_names: true)
              json_buffer = ""
              puts "[DEBUG] Parsed message: #{data[:type]}" if ENV["DEBUG"]
              yield data
            rescue JSON::ParserError
              # Continue accumulating until we have valid JSON
              next
            end
          end
        rescue IOError => e
          puts "[DEBUG] IOError reading stdout: #{e.message}" if ENV["DEBUG"]
        end

        # Handle process completion
        puts "[DEBUG] Waiting for process to complete..." if ENV["DEBUG"]
        @wait_thread.join
        exit_status = @wait_thread.value.exitstatus

        puts "[DEBUG] Process exited with status: #{exit_status}" if ENV["DEBUG"]

        unless exit_status.zero?
          stderr_output = @stderr.read
          puts "[DEBUG] stderr: #{stderr_output}" if ENV["DEBUG"]
          raise ProcessError.new(
            "Claude Code process failed",
            exit_code: exit_status,
            stderr: stderr_output
          )
        end
      ensure
        disconnect
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

      def read_stderr_with_timeout
        content = StringIO.new
        start_time = Time.now

        while (Time.now - start_time) < STDERR_TIMEOUT
          begin
            chunk = @stderr.read_nonblock(1024)
            content.write(chunk)

            # Stop if buffer is too large
            break if content.size > BUFFER_SIZE
          rescue IO::WaitReadable
            # No data available, check if we should continue
            break unless @stderr.wait_readable(0.1)
          rescue EOFError
            break
          end
        end

        content.string
      end
    end
  end
end
