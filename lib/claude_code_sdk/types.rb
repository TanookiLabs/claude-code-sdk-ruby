# frozen_string_literal: true

module ClaudeCodeSDK
  # Options for configuring Claude Code queries
  class Options
    attr_accessor :allowed_tools, :blocked_tools, :permission_mode,
                  :max_thinking_tokens, :system_prompt, :cwd,
                  :mcp_servers, :disable_cache, :no_markdown,
                  :tree, :tree_symlinks, :tree_verbose,
                  :max_turns, :model, :continue_conversation,
                  :resume, :append_system_prompt

    def initialize(**kwargs)
      @allowed_tools = kwargs[:allowed_tools] || []
      @blocked_tools = kwargs[:blocked_tools] || []
      @permission_mode = kwargs[:permission_mode] || "default"
      @max_thinking_tokens = kwargs[:max_thinking_tokens] || 8000
      @system_prompt = kwargs[:system_prompt]
      @cwd = kwargs[:cwd]
      @mcp_servers = kwargs[:mcp_servers] || {}
      @disable_cache = kwargs[:disable_cache] || false
      @no_markdown = kwargs[:no_markdown] || false
      @tree = kwargs[:tree] || []
      @tree_symlinks = kwargs[:tree_symlinks] || false
      @tree_verbose = kwargs[:tree_verbose] || false
      @max_turns = kwargs[:max_turns]
      @model = kwargs[:model]
      @continue_conversation = kwargs[:continue_conversation] || false
      @resume = kwargs[:resume]
      @append_system_prompt = kwargs[:append_system_prompt]
    end

    def to_cli_args
      args = ["--output-format", "stream-json", "--verbose"]

      args.push("--system-prompt", system_prompt) if system_prompt
      args.push("--append-system-prompt", append_system_prompt) if append_system_prompt
      args.push("--allowedTools", allowed_tools.join(",")) unless allowed_tools.empty?
      args.push("--disallowedTools", blocked_tools.join(",")) unless blocked_tools.empty?
      args.push("--max-turns", max_turns.to_s) if max_turns
      args.push("--model", model) if model
      args.push("--permission-mode", permission_mode) if permission_mode
      args.push("--continue") if continue_conversation
      args.push("--resume", resume) if resume
      args.push("--add-dir", cwd.to_s) if cwd

      unless mcp_servers.empty?
        require "json"
        mcp_config = { mcpServers: mcp_servers }.to_json
        args.push("--mcp-config", mcp_config)
      end

      args
    end
  end

  # Permission modes
  module PermissionMode
    DEFAULT = "default"
    ACCEPT_EDITS = "acceptEdits"
    BYPASS_PERMISSIONS = "bypassPermissions"
  end
end
