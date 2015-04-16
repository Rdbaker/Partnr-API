require 'rails_helper'

RSpec.describe "Signing In", :type => :request do
  before(:each) do
    @user = create(:user)
  end

  describe "POST /api/users/sign_in" do
    before(:each) do
      post "/api/users/sign_in", {
        "user" => {
          "email" => @user.email,
          "password" => @user.password
        }
      }
      @res = JSON.parse(response.body)
    end

    it "returns a 200" do
      expect(response.ok?)
    end

    it "this should fail" do
      expect(@res).to match_json_schema(:signin_res)
    end
  end
end
