require 'rails_helper'

RSpec.describe "Signing Up", :type => :request do
  before(:each) do
    @first_name = "Bob"
    @last_name = "Smith"
    @email = "ryan.da.baker@gmail.com"
    @password = "password"
  end

  describe "POST /api/users" do
    before(:each) do
      post "/api/users", {
        "user" => {
          "first_name" => @first_name,
          "last_name" => @last_name,
          "email" => @email,
          "password" => @password
        }
      }
    end

    it "returns a 200" do
      expect(response.ok?)
    end

    it "matches the expected schema" do
      expect(response.body).to match_json_schema(:signup_res)
    end
  end
end
