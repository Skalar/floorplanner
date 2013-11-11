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

    describe "class" do
      subject { described_class }

      its(:configuration) { should eq config }

      it "has an #endpoint_for_collection" do
        expect(subject.endpoint_for_collection).to eq 'http://test.floorplanner.com/test_resources.xml'
      end

      it "has an #endpoint_for_single" do
        expect(subject.endpoint_for_single 12).to eq 'http://test.floorplanner.com/test_resources/12.xml'
      end
    end


    it "is a resource" do
      expect(subject).to be_a Resource
    end
  end
end

