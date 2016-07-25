require 'rails_helper'

RSpec.describe "Projects", :type => :request do
  before(:each) do
    @project = build(:good_project)
    @project2 = build(:good_project2)

    @user = build(:user)
    @user2 = build(:user2)
    @user3 = build(:user3)
    @user.confirmed_at = Time.zone.now
    @user2.confirmed_at = Time.zone.now
    @user3.confirmed_at = Time.zone.now
    @user.save!
    @user2.save!
    @user3.save!

    @project.owner = @user.id
    @project.creator = @user.id
    @project.user_notifier = @user
    @project2.owner = @user2.id
    @project2.creator = @user2.id
    @project2.user_notifier = @user2

    @project.save!
    @project2.save!

    @role = build(:role)
    @role.user = @user3
    @role.project = @project
    @role.user_notifier = @user3
    @role.save!
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
    end

    context "with a supplied user id" do
      before(:each) do
        get "/api/v1/projects", owner: @user.id
        @res = JSON.parse(response.body)
      end

      it "returns one project" do
        expect(@res.length).to eq(1)
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
    end
  end


  context "unauthenticated user" do
    describe "POST /api/v1/projects" do
      before(:each) do
        logout(@user)
        post "/api/v1/projects", {
          "title" => "a brand new project",
          "description" => "this is just a test, I suppose"
        }
        login_as(@user, :scope => :user)
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

    after(:each) do
      logout(@user)
    end

    describe "POST /api/v1/projects" do
      before(:each) do
        @title = "a brand new project"
        @description = "this is just a test, I suppose"
        post "/api/v1/projects", {
          "title" => @title,
          "description" => @description
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

      it "has all the attributes we would expect" do
        expect(@res["owner"]["id"]).to eq(@user.id)
        expect(@res["creator"]).to eq(@user.id)
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
          @project.save!
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
      end

      context "user has proper permissions changing the status" do
        before(:each) do
          @project.owner = @user.id
          @project.save!
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
      end
    end


    describe "DELETE /api/v1/projects/:id" do
      context "user does not belong to project" do
        before(:each) do
          delete "/api/v1/projects/#{@project2.id}"
        end

        it "returns a 401" do
          expect(response.status).to eq(401)
        end
      end

      context "user belongs to project" do
        before(:each) do
          login_as(@user3, :scope => :user)
          delete "/api/v1/projects/#{@project.id}"
        end

        it "returns a 401" do
          expect(response.status).to eq(401)
        end

        after(:each) do
          logout(@user3)
          login_as(@user, :scope => :user)
        end
      end

      context "user owns the project" do
        before(:each) do
          @project.owner = @user.id
          @project.save!
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
