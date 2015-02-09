require 'rails_helper'

RSpec.describe User, :type => :model do
  before(:each) do
    @user = build(:user)
  end

  describe "#name" do
    it "returns the first and last name of the user" do
      name = @user.name
      expected = @user.first_name + " " + @user.last_name

      expect(name).to eq(expected)
    end
  end

  describe "#mailboxer_email" do
    it "returns the email of the user" do
      email = @user.mailboxer_email([])
      expected = @user.email

      expect(email).to eq(expected)
    end
  end
end
