require 'rails_helper'

RSpec.describe "Roles", :type => :request do
  before(:each) do
    @role = build(:role)
    @role2 = build(:role2)
    @user = create(:user)
    @project = create(:good_project)

    @role.project = @project
    @role.user = @user
    @role.save
  end

  describe "GET /api/v1/roles" do
    it "returns a 200" do
      get "/api/v1/roles"
      expect(response.ok?)
    end

    context "without a supplied user id" do
      before(:each) do
        get "/api/v1/roles"
        @res = JSON.parse(response.body)
      end

      it "returns two roles" do
        expect(@res.length).to eq(2)
      end

      it "matches the JSON schema" do
        expect(@res[0]).to match_json_schema(:role)
        expect(@res[1]).to match_json_schema(:role)
      end
    end

    context "with a supplied user id" do
      before(:each) do
        get "/api/v1/roles", user_id: @user.id
        @res = JSON.parse(response.body)
      end

      it "returns one role" do
        expect(@res.length).to eq(1)
      end

      it "matches the JSON schema" do
        expect(@res[0]).to match_json_schema(:role)
      end

      it "has a user with the supplied id" do
        expect(@res.all? { |r| r[:user] == @user.id })
      end
    end
  end

  describe "GET /api/v1/roles/:id" do
    context "bad request" do
      before(:each) do
        get "/api/v1/roles/0"
        @res = JSON.parse(response.body)
      end

      it "returns a 404" do
        expect(response.status).to eq(404)
      end
    end

    context "good request" do
      before(:each) do
        get "/api/v1/roles/#{@role.id}"
        @res = JSON.parse(response.body)
      end

      it "returns a 200" do
        expect(response.ok?)
      end

      it "returns JSON Schema conforming role" do
        expect(@res).to match_json_schema(:role)
      end
    end
  end


  context "unauthenticated user" do
    describe "POST /api/v1/roles" do
      before(:each) do
        post "/api/v1/roles", {
          "title" => "Some title",
          "project" => @project.id
        }
      end

      it "returns a 401" do
        expect(response.status).to eq(401)
      end
    end

    describe "PUT /api/v1/roles/:id" do
      before(:each) do
        put "/api/v1/roles/#{@role.id}", {
          "user" => @user.id
        }
      end

      it "returns a 401" do
        expect(response.status).to eq(401)
      end
    end

    describe "DELETE /api/v1/roles/:id" do
      before(:each) do
        delete "/api/v1/roles/#{@role.id}"
      end

      it "returns a 401" do
        expect(response.status).to eq(401)
      end
    end
  end


  context "authenticated user" do
    before(:each) do
      login_as(@user, :scope => :user)
    end

    describe "POST /api/v1/roles" do

      context "good request" do
        before(:each) do
          @title = "Some title"
          @project = @project.id
          post "/api/v1/roles", {
            "title" => @title,
            "project" => @project
          }
          @res = JSON.parse(response.body)
        end

        it "returns a 200" do
          expect(response.ok?)
        end

        it "has all the proper attributes we gave it" do
          expect(@res["title"]).to eq(@title)
          expect(@res["project"]).to eq(@project)
          expect(@res["user"]).to eq(nil)
        end

        it "returns a JSON Schema conforming project" do
          expect(@res).to match_json_schema(:role)
        end
      end


      context "bad request" do
        before(:each) do
          @title = "Some title"
          post "/api/v1/roles", {
            "title" => @title
          }
        end

        it "returns a 400" do
          expect(response.status).to eq(400)
        end
      end
    end

    describe "PUT /api/v1/roles/:id" do
      context "user does not have permissions" do
        before(:each) do
          put "/api/v1/roles/#{@role2.id}", {
            "title" => "the new title for this role"
          }
        end

        it "returns a 401" do
          expect(response.status).to eq(401)
        end
      end

      context "user has proper permissions via project ownership" do
        before(:each) do
          @project.owner = @user.id
          @project.save
          @title = "the new title for this role"
          put "/api/v1/roles/#{@role.id}", {
            "title" => @title
          }
          @res = JSON.parse(response.body)
        end

        it "returns a 200" do
          expect(response.ok?)
        end

        it "returns the updated role" do
          expect(@res["title"]).to eq(@title)
        end

        it "returns a JSON Schema conforming role" do
          expect(@res).to match_json_schema(:role)
        end
      end

      context "user has proper permissions via role ownership" do
        before(:each) do
          @role.user = @user
          @role.save
          @title = "the new title for this role"
          put "/api/v1/roles/#{@role.id}", {
            "title" => @title
          }
          @res = JSON.parse(response.body)
        end

        it "returns a 200" do
          expect(response.ok?)
        end

        it "returns the updated role" do
          expect(@res["title"]).to eq(@title)
        end

        it "returns a JSON Schema conforming role" do
          expect(@res).to match_json_schema(:role)
        end
      end
    end

    describe "DELETE /api/v1/roles/:id" do
      context "user does not have permissions" do
        before(:each) do
          @role2.user = @user.id+1
          @role2.project = @project
          @project.owner = @user.id+1

          @role2.save
          @project.save
          delete "/api/v1/roles/#{@role2.id}"
        end

        it "returns a 401" do
          expect(response.status).to eq(401)
        end
      end

      context "user has proper permissions" do
        before(:each) do
          @role.project = @project
          @project.owner = @user.id
          @project.save
          @role.save
          delete "/api/v1/roles/#{@project.id}"
          @res = JSON.parse(response.body)
        end

        it "returns a 200" do
          expect(response.ok?)
        end

        it "deletes the role" do
          get "/api/v1/roles/#{@role.id}"
          expect(response.status).to eq(404)
        end
      end
    end
  end


end
