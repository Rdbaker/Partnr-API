require 'rails_helper'

RSpec.describe Role, :type => :model do
  before(:each) do
    @role = build(:role)
    @project = build(:good_project)
    @user = build(:user)
    @user2 = build(:user2)
    @user3 = build(:user3)

    # set their IDs
    @project.id = 1
    @role.id = 1
    @user.id = 1
    @user2.id = 2
    @user3.id = 3

    # @user is the project owner
    @project.owner = @user.id
    # @user2 has the project role
    @role.user = @user2
    # @project is the @role's project
    @role.project = @project

    @user.save
    @user2.save
    @user3.save
    @project.save
    @role.save
  end

  describe "#has_admin_permissions" do
    it "fails if it isn't given a user" do
      expect(@role.has_admin_permissions(4)).to be false
    end

    it "passes if the user is the project owner" do
      expect(@role.has_admin_permissions(@user)).to be true
    end

    it "passes if the user has the project role" do
      expect(@role.has_admin_permissions(@user2)).to be true
    end

    it "fails otherwise" do
      expect(@role.has_admin_permissions(@user3)).to be false
    end
  end
end
