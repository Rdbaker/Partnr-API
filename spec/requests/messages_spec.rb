require 'rails_helper'

RSpec.describe "Messages", :type => :request do
  describe "GET /messages" do
    it "returns a 200" do
      get messages_path

      expect(response.ok?)
    end
  end

  describe "POST /messages" do
    it "returns a 200" do
      post messages_path

      expect(response.ok?)
    end
  end

  describe "GET /messages/:id" do
    it "returns a 200" do
      params = {
        :id => '1'
      }
      get '/messages', params

      expect(response.ok?)
    end

    it "redirects to a 404 if no conversation is found" do
      params = {
        :id => '-1'
      }
      get '/messages', params

      expect(response.code).to eq("302")
    end
  end

  describe "PUT /messages/:id" do
    it "returns a 200" do
      put '/messages/1'

      expect(response.ok?)
    end
  end

end
