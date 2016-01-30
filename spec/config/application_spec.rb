require 'rails_helper'

RSpec.describe Partnr::Application, 'configuration' do
  describe "#version" do
    it "returns a string" do
      expect(subject.version().class).to eq(String)
    end

    it "is v1.0.3" do
      expect(subject.version).to eq("1.0.3")
    end
  end
end
