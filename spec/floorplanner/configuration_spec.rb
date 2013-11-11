require 'spec_helper'

describe Floorplanner::Configuration do
  describe "#initialize" do
    it "sets password to x, as it is API's default requirement" do
      config = described_class.new
      expect(config.api_password).to eq 'x'
    end

    it "assigns incomming attributes" do
      config = described_class.new api_key: 'top-secret'
      expect(config.api_key).to eq 'top-secret'
    end
  end
end
