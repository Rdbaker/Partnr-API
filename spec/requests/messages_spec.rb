require 'rails_helper'

RSpec.describe "Messages", :type => :request do
  before(:each) do
    @user = build(:user)
    @user2 = build(:user2)
    @user.confirmed_at = Time.zone.now
    @user2.confirmed_at = Time.zone.now
    @user.save!
    @user2.save!

    @user.send_message(@user2, "body", "subject")
    login_as(@user, :scope => :user)
    @msg_id = @user.mailbox.conversations.first.id
  end

  describe "GET /api/v1/messages" do
    before(:each) do
      get "/api/v1/messages"
    end

    it "returns a 200" do
      expect(response.status).to eq(200)
    end

    it "returns json" do
      expect(response.content_type).to eq("application/json")
    end
  end

  describe "POST /api/v1/messages" do
    before(:each) do
      post "/api/v1/messages", {
        "email" => "ryan.da.baker@gmail.com",
        "message" => "hello"
      }
    end

    it "returns a 201" do
      expect(response.status).to eq(201)
    end
  end

  describe "GET /api/v1/messages/:id" do
    context "good message id" do
      before(:each) do
        get "/api/v1/messages/#{@msg_id}"
      end

      it "returns a 200" do
        expect(response.status).to eq(200)
      end

      it "returns json" do
        expect(response.content_type).to eq("application/json")
      end
    end

    context "bad message id" do
      before(:each) do
        get "/api/v1/messages/0"
      end

      it "returns a 404 if no conversation is found" do
        expect(response.status).to eq(404)
      end
    end
  end

  describe "PUT /api/v1/messages/:id" do
    before(:each) do
      put "/api/v1/messages/#{@msg_id}", {
        "message" => "hello"
      }
    end

    it "returns a 200" do
      expect(response.status).to eq(200)
    end
  end

end
