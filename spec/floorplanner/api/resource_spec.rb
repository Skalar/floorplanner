require 'spec_helper'


module Floorplanner::Api
  class TestResource < Resource
  end

  describe TestResource do
    let(:config) do
      Floorplanner::Configuration.new api_subdomain: 'test', api_key: 'test'
    end

    before do
      described_class.configuration = config
    end


    its(:configuration) { should eq config }
    its(:endpoint) { should eq 'http://test.floorplanner.com/test_resources.xml' }

    it "is a resource" do
      expect(subject).to be_a Resource
    end
  end
end

