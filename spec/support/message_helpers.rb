# frozen_string_literal: true

require "securerandom"

module MessageHelpers
  def create_user_message(text)
    ClaudeCodeSDK::UserMessage.new(id: SecureRandom.uuid, text: text)
  end

  def create_assistant_message(text)
    ClaudeCodeSDK::AssistantMessage.new(
      id: SecureRandom.uuid,
      content: [ClaudeCodeSDK::Content::TextBlock.new(text: text)]
    )
  end
end

RSpec.configure do |config|
  config.include MessageHelpers
end
