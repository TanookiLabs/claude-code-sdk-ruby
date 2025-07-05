# frozen_string_literal: true

module ClaudeCodeSDK
  # Base error class for all SDK errors
  class Error < StandardError; end

  # Raised when unable to connect to Claude Code CLI
  class CLIConnectionError < Error; end

  # Raised when Claude Code CLI is not found
  class CLINotFoundError < CLIConnectionError
    attr_reader :cli_path

    def initialize(message = "Claude Code not found", cli_path: nil)
      @cli_path = cli_path
      super(cli_path ? "#{message}: #{cli_path}" : message)
    end
  end

  # Raised when the CLI process fails
  class ProcessError < Error
    attr_reader :exit_code, :stderr

    def initialize(message, exit_code: nil, stderr: nil)
      @exit_code = exit_code
      @stderr = stderr

      full_message = message
      full_message += " (exit code: #{exit_code})" if exit_code
      full_message += "\nError output: #{stderr}" if stderr && !stderr.empty?

      super(full_message)
    end
  end

  # Raised when JSON parsing fails
  class CLIJSONDecodeError < Error
    attr_reader :line

    def initialize(message, line: nil)
      @line = line
      super(line ? "#{message}\nLine: #{line}" : message)
    end
  end
end
