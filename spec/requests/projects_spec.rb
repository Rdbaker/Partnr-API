require 'rails_helper'

RSpec.describe "Projects", :type => :request do
  before(:each) do
    @project = create(:good_project)
    @project2 = create(:good_project2)

    @user = create(:user)
    @user2 = create(:user2)

    @project.owner = @user.id
    @project.creator = @user.id
    @project2.owner = @user2.id
    @project2.creator = @user2.id

    @project.save!
    @project2.save!
  end


  describe "GET /api/v1/projects" do
    it "returns a 200" do
      get "/api/v1/projects"
      expect(response.status).to eq(200)
    end

    context "without a supplied user id" do
      before(:each) do
        get "/api/v1/projects"
        @res = JSON.parse(response.body)
      end

      it "returns two projects" do
        expect(@res.length).to eq(2)
      end

      it "matches the JSON schema" do
        expect(@res[0]).to match_json_schema(:shallow_project)
        expect(@res[1]).to match_json_schema(:shallow_project)
      end
    end

    context "with a supplied user id" do
      before(:each) do
        get "/api/v1/projects", owner: @user.id
        @res = JSON.parse(response.body)
      end

      it "returns one project" do
        expect(@res.length).to eq(1)
      end

      it "matches the JSON schema" do
        expect(@res[0]).to match_json_schema(:shallow_project)
      end

      it "has an owner with the supplied id" do
        expect(@res.all? { |p| p[:owner] == @user.id })
      end
    end
  end


  describe "GET /api/v1/projects/:id" do
    context "bad request" do
      before(:each) do
        get "/api/v1/projects/0"
        @res = JSON.parse(response.body)
      end

      it "returns a 404" do
        expect(response.status).to eq(404)
      end
    end

    context "good request" do
      before(:each) do
        get "/api/v1/projects/#{@project.id}"
        @res = JSON.parse(response.body)
      end

      it "returns a 200" do
        expect(response.status).to eq(200)
      end

      it "returns JSON Schema conforming project" do
        expect(@res).to match_json_schema(:deep_project)
      end
    end
  end


  context "unauthenticated user" do
    describe "POST /api/v1/projects" do
      before(:each) do
        post "/api/v1/projects", {
          "title" => "a brand new project",
          "description" => "this is just a test, I suppose",
          "owner" => @user.id
        }
      end

      it "returns a 401" do
        expect(response.status).to eq(401)
      end
    end

    describe "PUT /api/v1/projects/:id" do
      before(:each) do
        put "/api/v1/projects/#{@project.id}", {
          "title" => "the new title for this project"
        }
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

    describe "POST /api/v1/projects" do
      before(:each) do
        @title = "a brand new project"
        @description = "this is just a test, I suppose"
        post "/api/v1/projects", {
          "title" => @title,
          "description" => @description,
          "owner" => @user.id
        }
        @res = JSON.parse(response.body)
      end

      it "returns a 201" do
        expect(response.status).to eq(201)
      end

      it "has all the proper attributes we gave it" do
        expect(@res["title"]).to eq(@title)
        expect(@res["description"]).to eq(@description)
        expect(@res["owner"]["id"]).to eq(@user.id)
      end

      it "returns a JSON Schema conforming project" do
        expect(@res).to match_json_schema(:shallow_project)
      end
    end


    describe "PUT /api/v1/projects/:id" do
      context "user does not have permissions" do
        before(:each) do
          put "/api/v1/projects/#{@project2.id}", {
            "title" => "the new title for this project"
          }
        end

        it "returns a 401" do
          expect(response.status).to eq(401)
        end
      end

      context "user has proper permissions" do
        before(:each) do
          @project.owner = @user.id
          @project.save
          @title = "the brand new title for this project"
          put "/api/v1/projects/#{@project.id}", {
            "title" => @title
          }
          @res = JSON.parse(response.body)
        end

        it "returns a 200" do
          expect(response.status).to eq(200)
        end

        it "returns the updated project" do
          expect(@res["title"]).to eq(@title)
        end

        it "returns a JSON Schema conforming project" do
          expect(@res).to match_json_schema(:shallow_project)
        end
      end

      context "user has proper permissions changing the status" do
        before(:each) do
          @project.owner = @user.id
          @project.save
          @status = "complete"
          put "/api/v1/projects/#{@project.id}", {
            "status" => @status
          }
          @res = JSON.parse(response.body)
        end

        it "returns a 200" do
          expect(response.status).to eq(200)
        end

        it "returns the updated project" do
          expect(@res["status"]).to eq(@status)
        end

        it "returns a JSON Schema conforming project" do
          expect(@res).to match_json_schema(:shallow_project)
        end
      end

    end


    describe "DELETE /api/v1/projects/:id" do
      context "user does not have permissions" do
        before(:each) do
          delete "/api/v1/projects/#{@project2.id}"
        end

        it "returns a 401" do
          expect(response.status).to eq(401)
        end
      end

      context "user has proper permissions" do
        before(:each) do
          @project.owner = @user.id
          @project.save
          delete "/api/v1/projects/#{@project.id}"
        end

        it "returns a 204" do
          expect(response.status).to eq(204)
        end

        it "deletes the project" do
          get "/api/v1/projects/#{@project.id}"
          expect(response.status).to eq(404)
        end
      end
    end
  end


end
