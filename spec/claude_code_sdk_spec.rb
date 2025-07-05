# frozen_string_literal: true

require "spec_helper"

RSpec.describe ClaudeCodeSDK do
  describe ".query" do
    let(:mock_transport) { instance_double(ClaudeCodeSDK::Transport::SubprocessCLI) }

    before do
      allow(ClaudeCodeSDK::Transport::SubprocessCLI).to receive(:new).and_return(mock_transport)
      allow(mock_transport).to receive(:connect)
      allow(mock_transport).to receive(:disconnect)
      allow(mock_transport).to receive(:receive_messages)
    end

    it "yields messages from the transport" do
      messages = [
        { type: "user", id: "1", text: "Hello" },
        { type: "assistant", id: "2", content: [{ type: "text", text: "Hi there!" }] }
      ]

      allow(mock_transport).to receive(:receive_messages) do |&block|
        messages.each { |msg| block.call(msg) }
      end

      received = []
      described_class.query("Hello") { |msg| received << msg }

      expect(received.size).to eq(2)
      expect(received.first).to be_a(ClaudeCodeSDK::UserMessage)
      expect(received.last).to be_a(ClaudeCodeSDK::AssistantMessage)
    end

    context "with options" do
      it "accepts a hash of options" do
        expect(ClaudeCodeSDK::Options).to receive(:new).with(
          system_prompt: "Be helpful",
          allowed_tools: ["read_file"]
        ).and_call_original

        described_class.query("Hello",
                              system_prompt: "Be helpful",
                              allowed_tools: ["read_file"])
      end

      it "accepts an Options object" do
        options = ClaudeCodeSDK::Options.new(system_prompt: "Be helpful")

        expect(ClaudeCodeSDK::Transport::SubprocessCLI).to receive(:new).with(
          prompt: "Hello",
          options: options
        ).and_return(mock_transport)

        described_class.query("Hello", options)
      end
    end
  end

  describe ".ask" do
    it "returns concatenated text response" do
      allow(described_class).to receive(:query).and_yield(
        ClaudeCodeSDK::AssistantMessage.new(
          id: "1",
          content: [
            ClaudeCodeSDK::Content::TextBlock.new(text: "Hello!"),
            ClaudeCodeSDK::Content::TextBlock.new(text: " How are you?")
          ]
        )
      )

      result = described_class.ask("Hi")
      expect(result).to eq("Hello!\n How are you?")
    end
  end
end
