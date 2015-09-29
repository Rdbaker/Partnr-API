require 'rails_helper'

RSpec.describe "States", :type => :request do
  before(:each) do
    @state = build(:state)
    @state2 = build(:state2)
    @state3 = build(:state3)
    @state4 = build(:state4)

    # owner
    @user = create(:user)
    # participant
    @user2 = create(:user2)
    @role = build(:role)
    # anybody else
    @user3 = create(:user3)
    @project = create(:good_project)

    @state.project = @project
    @state2.project = @project
    @state3.project = @project
    @state4.project = @project

    @role.user = @user2
    @role.project = @project

    @project.owner = @user

    @state.save
    @state2.save
    @state3.save
    @state4.save
    @project.save
    @role.save
  end

  context "as the project owner" do
    before(:each) do
      login_as(@user, :scope => :user)
    end

    describe "GET /api/v1/states/:id" do
      before(:each) do
        get "/api/v1/states/#{@state.id}"
        @res = JSON.parse(response.body)
      end

      it "returns a 200" do
        expect(response.status).to eq(200)
      end

      it "returns a JSON Schema conforming state" do
        expect(@res).to match_json_schema(:shallow_state)
      end
    end

    describe "POST /api/v1/states" do
      before(:each) do
        @name = "new state"
        post "/api/v1/states", {
          "name" => @name,
          "project_id" => @project.id
        }
        @res = JSON.parse(response.body)
      end

      it "returns a 201" do
        expect(response.status).to eq(201)
      end

      it "has all the proper attributes we gave it" do
        expect(@res["name"]).to eq(@name)
        expect(@res["project"]["id"]).to eq(@project.id)
      end
    end

  end

  context "as a project participant" do
  end

  context "as anybody else" do
    before(:each) do
      login_as(@user3, :scope => :user)
    end

    describe "POST /api/v1/states" do
      before(:each) do
        @name = "new state"
        post "/api/v1/states", {
          "name" => @name,
          "project_id" => @project.id
        }
        @res = JSON.parse(response.body)
      end

      it "should return a 401" do
        expect(response.status).to eq(401)
      end
    end

  end
end
