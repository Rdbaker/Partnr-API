require 'rails_helper'

RSpec.describe "Inbox", :type => :request do
  describe "Schema" do
    before(:each) do
      @user = create(:user)
      @user2 = create(:user2)
      @user.send_message(@user2, "body", "subject")
      login_as(@user, :scope => :user)
    end

    after(:each) do
      Warden.test_reset!
    end

    it "works" do
      get '/api/messages'
      expect(response.body).to match_json_schema(:inbox)
    end
  end
end
