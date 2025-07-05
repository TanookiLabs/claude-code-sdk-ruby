# frozen_string_literal: true

module ClaudeCodeSDK
  module Transport
    # Abstract base class for transports
    class Base
      def connect
        raise NotImplementedError
      end

      def disconnect
        raise NotImplementedError
      end

      def connected?
        raise NotImplementedError
      end

      def receive_messages(&block)
        raise NotImplementedError
      end
    end
  end
end
