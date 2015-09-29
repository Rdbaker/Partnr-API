require 'rails_helper'

RSpec.describe Post, :type => :model do
  before(:each) do
    @role = build(:role)
    @project = build(:good_project)
    @user = build(:user)
    @user2 = build(:user2)
    @user3 = build(:user3)
    @post = build(:post)
    @state = build(:state)

    @project.id = 1
    @role.id = 1
    @user.id = 1
    @user2.id = 2
    @user3.id = 3
    @state.id = 1
    @post.id = 1

    # @user is the project owner
    @project.owner = @user.id
    # @user2 has the project role
    @role.user = @user2
    # project is the role's project
    @role.project = @project
    # project is the state's project
    @state.project = @project
    # state is the post's state
    @post.state = @state
    # user2 is the post's author
    @post.user = @user2

    @user.save
    @user2.save
    @user3.save
    @project.save
    @role.save
  end

  describe "#has_put_permissions" do
    it "fails if it isn't given a user" do
      expect(@post.has_put_permissions(4)).to be false
    end

    it "passes if the user is the project owner" do
      expect(@post.has_put_permissions(@user)).to be true
    end

    it "passes if the user is the author of the post" do
      expect(@post.has_put_permissions(@user2)).to be true
    end

    it "fails otherwise" do
      expect(@post.has_put_permissions(@user3)).to be false
    end
  end

  describe "#has_destroy_permissions" do
    it "fails if it isn't given a user" do
      expect(@post.has_put_permissions(4)).to be false
    end

    it "passes if the user is the project owner" do
      expect(@post.has_put_permissions(@user)).to be true
    end

    it "passes if the user is the author of the post" do
      expect(@post.has_put_permissions(@user2)).to be true
    end

    it "fails otherwise" do
      expect(@post.has_put_permissions(@user3)).to be false
    end
  end
end
