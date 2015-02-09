require 'rails_helper'

RSpec.describe MessagesHelper, :type => :helper do
  before(:each) do
    @user = build(:user)
    @user2 = build(:user2)
    @users = [@user, @user2]
  end

  describe "#conv_from_recipients" do
    it "returns nil if the list isn't only users" do
      expect(helper.conv_from_recipients []).to be_nil
    end

    it "returns nil if there isn't a conversation" do
      expect(helper.conv_from_recipients @users).to be_nil
    end

    it "returns the conversation between two users" do
      @user2.send_message(@user, "body", "subject")

      expect(helper.conv_from_recipients @users).to eq(
        @user.mailbox.conversations[0]
      )
    end

    it "only gets one conversation, even if there are two" do
      @user2.send_message(@user, "body", "subject")
      @user2.send_message(@user, "body2", "subject2")

      expect(helper.conv_from_recipients(@users).class).to eq(Mailboxer::Conversation)
      expect(@user.mailbox.conversations.length).to eq(2)
    end
  end

  describe "#json_conversations" do
    it "returns nil if it is not passed a user" do
      expect(helper.json_conversations []).to be_nil
    end

    it "returns an empty list if there are no conversations" do
      expect(helper.json_conversations @user).to eq []
    end

    it "returns an array of participants and ids for conversations" do
      @user2.send_message(@user, "body", "subject")
      conv_id = @user2.mailbox.conversations.all[0].id
      convs = [{
        "participants"=>[{
          "name" => @user2.name,
          "email" => @user2.email
        }],
        "id"=>conv_id
      }]

      expect(helper.json_conversations @user).to eq convs
    end
  end

  describe "#user_conversation" do
    it "returns an empty list if given wrong params" do
      expect(helper.user_conversation(@user, nil)).to eq([])
      expect(helper.user_conversation(nil, nil)).to eq([])
      expect(helper.user_conversation(nil, 1)).to eq([])
    end

    it "returns an empty list if the conversation doesn't exist" do
      expect(helper.user_conversation(@user, -1)).to eq([])
    end

    it "returns an array of message/sender objects" do
      @user.send_message(@user2, "body", "subject")
      conv = @user.mailbox.conversations.all[0]

      expect(helper.user_conversation(@user2, conv.id)).to eq([{"message" => conv.last_message, "sender" => @user.name}])
    end
  end
end
