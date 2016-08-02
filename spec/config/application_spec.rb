require 'rails_helper'

RSpec.describe Partnr::Application, 'configuration' do
  describe "#version" do
    it "returns a string" do
      expect(subject.version().class).to eq(String)
    end

    it "is v1.2.1" do
      expect(subject.version).to eq("1.2.1")
    end
  end
end
