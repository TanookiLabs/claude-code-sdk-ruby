# frozen_string_literal: true

module ClaudeCodeSDK
  module Internal
    class Client
      def initialize
        @transport = nil
      end

      def query(prompt:, options: nil, &block)
        # Use SubprocessCLI for streaming JSON support
        require_relative "../transport/subprocess_cli"
        @transport = Transport::SubprocessCLI.new(prompt: prompt, options: options)

        begin
          @transport.connect

          @transport.receive_messages do |raw_message|
            message = parse_message(raw_message)
            block.call(message) if message
          end
        ensure
          @transport&.disconnect
        end
      end

      private

      def parse_message(raw)
        case raw[:type]
        when "user"
          UserMessage.new(
            id: raw[:id] || "user-#{Time.now.to_f}",
            text: raw[:text] || raw[:prompt]
          )
        when "assistant"
          # Handle the actual CLI format
          if raw[:message]
            msg = raw[:message]
            AssistantMessage.new(
              id: msg[:id],
              content: parse_content_blocks(msg[:content] || [])
            )
          else
            AssistantMessage.new(
              id: raw[:id] || "assistant-#{Time.now.to_f}",
              content: parse_content_blocks(raw[:content] || [])
            )
          end
        when "system"
          # System messages from CLI have different structure
          SystemMessage.new(
            id: raw[:id] || "system-#{Time.now.to_f}",
            title: raw[:subtype] || "system",
            message: raw.to_json
          )
        when "result"
          ResultMessage.new(
            id: raw[:id] || "result-#{Time.now.to_f}",
            status: raw[:subtype] || raw[:status],
            cost: raw[:total_cost_usd] ? { usd: raw[:total_cost_usd] } : raw[:cost],
            usage: raw[:usage]
          )
        else
          # Unknown message type, skip
          nil
        end
      end

      def parse_content_blocks(content)
        content.map do |block|
          case block[:type]
          when "text"
            Content::TextBlock.new(text: block[:text])
          when "tool_use"
            Content::ToolUseBlock.new(
              id: block[:id],
              name: block[:name],
              input: block[:input]
            )
          when "tool_result"
            Content::ToolResultBlock.new(
              tool_use_id: block[:tool_use_id],
              output: block[:output],
              is_error: block[:is_error] || false
            )
          end
        end.compact
      end
    end
  end
end
