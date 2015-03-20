require 'rails_helper'

RSpec.describe "Messages", :type => :request do
  before(:each) do
    @user = create(:user)
    @user2 = create(:user2)
    @user.send_message(@user2, "body", "subject")
    login_as(@user, :scope => :user)
    @msg_id = @user.mailbox.conversations.first.id
  end

  describe "GET /api/messages" do
    before(:each) do
      get api_messages_path
    end

    it "returns a 200" do
      expect(response.ok?)
    end

    it "returns json" do
      expect(response.content_type).to eq("application/json")
    end
  end

  describe "POST /api/messages" do
    before(:each) do
      post api_messages_path
    end

    it "returns a 200" do
      expect(response.ok?)
    end
  end

  describe "GET /api/messages/:id" do
    it "returns a 200" do
      params = {
        :id => @msg_id
      }
      get '/api/messages', params

      expect(response.ok?)
    end

    it "returns json" do
      get "/api/messages/#{@msg_id}"

      expect(response.content_type).to eq("application/json")
    end

    it "returns a 404 if no conversation is found" do
      get '/api/messages/-1'

      expect(response.code).to eq("404")
    end
  end

  describe "PUT /api/messages/:id" do
    before(:each) do
      put "/api/messages/#{@msg_id}"
    end

    it "returns a 200" do
      expect(response.ok?)
    end
  end

end
