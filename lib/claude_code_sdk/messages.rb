# frozen_string_literal: true

module ClaudeCodeSDK
  # Base message class
  class Message
    attr_reader :id, :type

    def initialize(id:, type:)
      @id = id
      @type = type
    end
  end

  # User input message
  class UserMessage < Message
    attr_reader :text

    def initialize(id:, text:)
      super(id: id, type: "user")
      @text = text
    end
  end

  # Assistant response message
  class AssistantMessage < Message
    attr_reader :content, :thinking

    def initialize(id:, content:, thinking: nil)
      super(id: id, type: "assistant")
      @content = content # Array of content blocks
      @thinking = thinking # Optional thinking content
    end
  end

  # System message
  class SystemMessage < Message
    attr_reader :title, :message

    def initialize(id:, title:, message:)
      super(id: id, type: "system")
      @title = title
      @message = message
    end
  end

  # Final result message
  class ResultMessage < Message
    attr_reader :status, :cost, :usage

    def initialize(id:, status:, cost: nil, usage: nil)
      super(id: id, type: "result")
      @status = status
      @cost = cost
      @usage = usage
    end
  end

  # Thinking message (Claude's internal reasoning)
  class ThinkingMessage < Message
    attr_reader :content

    def initialize(id:, content:)
      super(id: id, type: "thinking")
      @content = content
    end
  end

  # Content blocks
  module Content
    class TextBlock
      attr_reader :type, :text

      def initialize(text:)
        @type = "text"
        @text = text
      end
    end

    class ToolUseBlock
      attr_reader :type, :id, :name, :input

      def initialize(id:, name:, input:)
        @type = "tool_use"
        @id = id
        @name = name
        @input = input
      end
    end

    class ToolResultBlock
      attr_reader :type, :tool_use_id, :output, :is_error

      def initialize(tool_use_id:, output:, is_error: false)
        @type = "tool_result"
        @tool_use_id = tool_use_id
        @output = output
        @is_error = is_error
      end
    end
  end
end
