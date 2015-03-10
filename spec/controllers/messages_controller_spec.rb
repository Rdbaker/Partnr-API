require 'rails_helper'

RSpec.describe MessagesController, :type => :controller do
  login_user

  before(:each) do
    @user2 = build(:user2)
    @user.send_message(@user2, "Body", "Subject")
  end

  describe "#index" do
    before(:each) do
      get :index
    end

    it "returns json" do
      expect(response.content_type).to eq("application/json")
    end

    it "returns a list of conversations with all included users" do
      expect(response.body).to eq(@user.json_conversations.to_json)
    end
  end

  describe "#create" do
  end
end
