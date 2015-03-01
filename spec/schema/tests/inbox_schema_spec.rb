require 'rails_helper'

RSpec.describe "Inbox", :type => :request do
  describe "Schema" do
    before(:each) do
      @user = build(:user)
      @user2 = build(:user2)
      @user.send_message(@user2, "body", "subject")
      sign_in @user
    end

    it "works" do
      get '/messages'
      puts response.body
      #expect(response.body).to match_json_schema(:inbox)
    end
  end
end
