require 'rails_helper'

RSpec.describe "Roles", :type => :request do
  before(:each) do
    @role = build(:role)
    @role2 = build(:role2)

    @application = build(:application)
    @application2 = build(:application2)

    @user = create(:user)
    @user2 = create(:user2)
    @user3 = create(:user3)

    @project = create(:good_project)
    @project2 = create(:good_project2)

    @project.owner = @user.id

    @role.project = @project
    @role2.project = @project2
    @role.user = @user
    @role2.user = nil

    @application.role = @role2
    @application.user = @user2
    @application.project = @project
    @application2.role = @role2
    @application2.user = @user3
    @application2.project = @project2

    @role.save
    @role2.save
    @application.save
    @application2.save
    @project.save
  end

  describe "GET /api/v1/applications" do
    it "returns a 200" do
      get "/api/v1/applications"
      expect(response.ok?)
    end

    context "without any query params" do
      before(:each) do
        get "/api/v1/applications"
        @res = JSON.parse(response.body)
      end

      it "returns two applications" do
        expect(@res.length).to eq(2)
      end

      it "matches the JSON schema" do
        expect(@res[0]).to match_json_schema(:shallow_application)
        expect(@res[1]).to match_json_schema(:shallow_application)
      end
    end

    context "with a supplied user id" do
      before(:each) do
        get "/api/v1/applications", user_id: @user2.id
        @res = JSON.parse(response.body)
      end

      it "returns one application" do
        expect(@res.length).to eq(1)
      end

      it "matches the JSON schema" do
        expect(@res[0]).to match_json_schema(:shallow_application)
      end
    end

    context "with a supplied project id" do
      before(:each) do
        get "/api/v1/applications", project_id: @project.id
        @res = JSON.parse(response.body)
      end

      it "returns one application" do
        expect(@res.length).to eq(1)
      end

      it "matches the JSON schema" do
        expect(@res[0]).to match_json_schema(:shallow_application)
      end
    end

    context "with a supplied role id" do
      before(:each) do
        get "/api/v1/applications", role_id: @role2.id
        @res = JSON.parse(response.body)
      end

      it "returns one application" do
        expect(@res.length).to eq(1)
      end

      it "matches the JSON schema" do
        expect(@res[0]).to match_json_schema(:shallow_application)
      end
    end
  end

  describe "GET /api/v1/applications/:id" do
    context "bad request" do
      before(:each) do
        get "/api/v1/applications/0"
        @res = JSON.parse(response.body)
      end

      it "returns a 404" do
        expect(response.status).to eq(404)
      end
    end

    context "good request" do
      before(:each) do
        get "/api/v1/applications/#{@application.id}"
        @res = JSON.parse(response.body)
      end

      it "returns a 200" do
        expect(response.ok?)
      end

      it "returns JSON Schema conforming application" do
        expect(@res).to match_json_schema(:deep_application)
      end
    end
  end


  context "unauthenticated user" do
    describe "POST /api/v1/applications" do
      before(:each) do
        post "/api/v1/applications", {
          "role_id" => @role.id
        }
        @res = JSON.parse(response.body)
      end

      it "returns a 401" do
        expect(response.status).to eq(401)
      end
    end

    describe "PUT /api/v1/applications/:id" do
      before(:each) do
        put "/api/v1/applications/#{@application.id}", {
          "status" => "cancelled"
        }
      end

      it "returns a 401" do
        expect(response.status).to eq(401)
      end
    end
  end


  context "authenticated user" do
    before(:each) do
      login_as(@user3, :scope => :user)
    end

    describe "POST /api/v1/applications" do

      context "good request" do
        before(:each) do
          post "/api/v1/applications", {
            "role_id" => @role2.id
          }
          @res = JSON.parse(response.body)
        end

        it "returns a 200" do
          expect(response.ok?)
        end

        it "has all the proper attributes we gave it" do
          expect(@res["status"]).to eq("pending")
        end

        it "returns a JSON Schema conforming application" do
          expect(@res).to match_json_schema(:shallow_application)
        end
      end


      context "bad request" do
        before(:each) do
          post "/api/v1/applications", {
            "role_id" => 0
          }
          @res = JSON.parse(response.body)
        end

        it "returns a 400" do
          expect(response.status).to eq(400)
        end
      end
    end

    describe "PUT /api/v1/applications/:id" do
      context "as the project owner" do
        before(:each) do
          @project.owner = @user3.id
          @project.save
        end

        context "status becomes cancelled" do
          before(:each) do
            put "/api/v1/applications/#{@application.id}", {
              "status" => "cancelled"
            }
            @res = JSON.parse(response.body)
          end

          it "returns a 401" do
            expect(response.status).to eq(401)
          end
        end

        context "status becomes accepted" do
          before(:each) do
            put "/api/v1/applications/#{@application.id}", {
              "status" => "accepted"
            }
            @res = JSON.parse(response.body)
          end

          it "returns a 200" do
            expect(response.ok?)
          end

          it "returns a JSON schema matching application" do
            expect(@res).to match_json_schema(:shallow_application)
          end

          it "changes to accepted" do
            expect(@res["status"]).to eq("accepted")
          end

          it "fills the role with the applicant" do
            expect(@application.role.user.id).to eq(@user2.id)
          end
        end

        context "status becomes rejected" do
          before(:each) do
            put "/api/v1/applications/#{@application.id}", {
              "status" => "rejected"
            }
            @res = JSON.parse(response.body)
          end

          it "returns a 200" do
            expect(response.ok?)
          end

          it "returns a JSON schema matching application" do
            expect(@res).to match_json_schema(:shallow_application)
          end

          it "changes to rejected" do
            expect(@res["status"]).to eq("rejected")
          end
        end

      end

      context "as a role applicant" do
        before(:each) do
          @application.user = @user3
          @application.save
        end

        context "status becomes cancelled" do
          before(:each) do
            put "/api/v1/applications/#{@application.id}", {
              "status" => "cancelled"
            }
            @res = JSON.parse(response.body)
          end

          it "returns a 200" do
            expect(response.ok?)
          end

          it "returns a JSON schema matching application" do
            expect(@res).to match_json_schema(:shallow_application)
          end

          it "changes to accepted" do
            expect(@res["status"]).to eq("cancelled")
          end
        end

        context "status becomes rejected" do
          before(:each) do
            put "/api/v1/applications/#{@application.id}", {
              "status" => "rejected"
            }
            @res = JSON.parse(response.body)
          end

          it "returns a 401" do
            expect(response.status).to eq(401)
          end
        end

        context "status becomes accepted" do
          before(:each) do
            put "/api/v1/applications/#{@application.id}", {
              "status" => "accepted"
            }
            @res = JSON.parse(response.body)
          end

          it "returns a 401" do
            expect(response.status).to eq(401)
          end
        end

        context "status is rejected" do
          before(:each) do
            @application.status = "rejected"
            @application.save
          end

          it "allows no change of status" do
            put "/api/v1/applications/#{@application.id}", {
              "status" => "pending"
            }
            expect(response.status).to eq(401)

            put "/api/v1/applications/#{@application.id}", {
              "status" => "cancelled"
            }
            expect(response.status).to eq(401)
          end
        end
      end

      context "as anybody else" do
        before(:each) do
          @application.user = @user2
          @project.owner = @user.id
          @application.save
          @project.save
        end

        it "doesn't allow any change" do
          put "/api/v1/applications/#{@application.id}", {
            "status" => "pending"
          }
          expect(response.status).to eq(401)

          put "/api/v1/applications/#{@application.id}", {
            "status" => "cancelled"
          }
          expect(response.status).to eq(401)

          put "/api/v1/applications/#{@application.id}", {
            "status" => "rejected"
          }
          expect(response.status).to eq(401)

          put "/api/v1/applications/#{@application.id}", {
            "status" => "accepted"
          }
          expect(response.status).to eq(401)
        end
      end
    end
  end

end
