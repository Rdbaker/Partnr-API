require 'rails_helper'

RSpec.describe ProjectsController, :type => :controller do
  login_user

  before(:each) do
    @user.projects = [Project.new(name:"Project",
                                  owner:@user.id,
                                  creator:@user.id)]
  end

  describe "#index" do
    before(:each) do
      get :index
    end

    it "returns JSON" do
      expect(response.content_type).to eq("application/json")
    end

    it "returns a list of all of the user's projects" do
      expect(response.body).to eq(@user.projects.to_json)
    end
  end

  describe "#create" do
    context "with invalid attributes" do
      it "does not save the project to the db" do
        expect{ post :create, project: attributes_for(:invalid_project) }
          .to_not change(Project,:count)
      end
    end

    context "with valid attributes" do
      it "saves the project to the db" do
        expect{ post :create, project: attributes_for(:good_project) }
          .to change(Project, :count).by(1)
      end

      it "redirects to the #index action" do
        post :create, project: attributes_for(:good_project)
        expect(response).to redirect_to :projects
      end
    end
  end

  describe "#show" do
    before(:each) do
      @project = create(:good_project)
      get :show, id: @project.id
    end

    it "returns JSON by default" do
      expect(response.content_type).to eq("application/json")
    end

    it "returns a serialized JSON version of the project" do
      expect(response.body).to eq(@project.to_json)
    end
  end

  describe "#update" do
    before(:each) do
      @project = create(:good_project)
    end

    context "with valid attributes" do
      before(:each) do
        @project.owner = @user.id
        @project.save
        put :update, id: @project.id, project: { 'name' => "New Name" }
      end

      it "redirects to the project show page" do
        expect(response).to redirect_to :project
      end

      it "changes the actual value of the project" do
        get :show, id: @project.id
        expect(JSON.parse(response.body)['name']).to eq("New Name")
      end

      it "can't change the 'creator' attribute" do
        @project.creator = @user.id+1
        @project.save
        put :update, id: @project.id, project: { 'creator' => @user.id }
        get :show, id: @project.id
        expect(JSON.parse(response.body)['creator']).to_not eq(@user.id)
      end
    end

    context "with invalid attributes" do
      before(:each) do
        @project.owner = @user.id+1
        @project.save
        put :update, id: @project.id, project: { 'name' => "New Name" }
      end

      it "responds with an error" do
        expect(response.code).to eq('401')
      end

      it "explicitly says the error" do
        error_msg = "You don't have the permissions to do that"
        expect(JSON.parse(response.body)['error']).to eq(error_msg)
      end
    end
  end

  describe "#destroy" do
    before(:each) do
      @project = create(:good_project)
    end

    context "user doesn't have destroy permissions" do
      before(:each) do
        @project.owner = @user.id+1
        @project.save
        delete :destroy, id: @project.id
      end

      it "responds with an error" do
        expect(response.code).to eq('401')
      end

      it "explicitly says the error" do
        error_msg = "You don't have the permissions to do that"
        expect(JSON.parse(response.body)['error']).to eq(error_msg)
      end
    end

    context "user has destroy permissions" do
      before(:each) do
        @project.owner = @user.id
        @project.save
      end

      it "destroys the project" do
        expect{ delete :destroy, id: @project.id }
          .to change(Project, :count).by(-1)
      end

      it "redirects to the index" do
        delete :destroy, id: @project.id
        expect(response).to redirect_to :projects
      end
    end
  end
end
