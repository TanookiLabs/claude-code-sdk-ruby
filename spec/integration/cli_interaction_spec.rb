# frozen_string_literal: true

require "spec_helper"

RSpec.describe "CLI Interaction", :integration do
  it "successfully queries Claude Code" do
    skip "Requires Claude Code CLI installed" unless cli_available?

    messages = []

    ClaudeCodeSDK.query("What is 2+2?") do |message|
      messages << message
    end

    expect(messages).not_to be_empty
    expect(messages.last).to be_a(ClaudeCodeSDK::ResultMessage)
    expect(messages.last.status).to eq("success")
  end

  def cli_available?
    system("which claude > /dev/null 2>&1") || system("which claude-code > /dev/null 2>&1")
  end
end
