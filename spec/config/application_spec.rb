require 'rails_helper'

RSpec.describe Partnr::Application, 'configuration' do
  describe "#version" do
    it "returns a string" do
      expect(subject.version().class).to eq(String)
    end

    it "is v0.2.0" do
      expect(subject.version).to eq("0.2.0")
    end
  end
end
