require "spec_helper"

describe Floorplanner::Models::Export do
  describe "#errors" do
    it "is empty if width, height and callback are given" do
      export = described_class.new(
        resolution: Floorplanner::Models::Resolution.new(width: 100, height: 200),
        callback: "http://example.com"
      )

      expect(export.errors).to be_empty
    end

    it "is empty if width, height and send_to are given" do
      export = described_class.new(
        resolution: Floorplanner::Models::Resolution.new(width: 100, height: 200),
        send_to: "foo@test.com"
      )

      expect(export.errors).to be_empty
    end

    it "contains an error if resolution is nil" do
      export = described_class.new(
        callback: "http://example.com"
      )

      expect(export.errors).to include("resolution must be set")
    end

    it "contains an error if width is nil" do
      export = described_class.new(
        resolution: Floorplanner::Models::Resolution.new(height: 200),
        callback: "http://example.com"
      )

      expect(export.errors).to include("resolution#width is missing")
    end

    it "contains an error if height is nil" do
      export = described_class.new(
        resolution: Floorplanner::Models::Resolution.new(width: 200),
        callback: "http://example.com"
      )

      expect(export.errors).to include("resolution#height is missing")
    end

    it "contains an error if both callback and send_to are nil" do
      export = described_class.new(
        resolution: Floorplanner::Models::Resolution.new(width: 200),
      )

      expect(export.errors).to include("a value must be supplied for callback or send_to")
    end

    it "contains an error if both callback and send_to are empty" do
      export = described_class.new(
        resolution: Floorplanner::Models::Resolution.new(width: 200),
        callback: "",
        send_to: ""
      )

      expect(export.errors).to include("a value must be supplied for callback or send_to")
    end

    it "contains an error if both callback and send_to are given" do
      export = described_class.new(
        resolution: Floorplanner::Models::Resolution.new(width: 200),
        callback: "http://example.com",
        send_to: "foo@test.com"
      )

      expect(export.errors).to include("supply either callback or send_to, not both")
    end
  end

  describe "#to_xml" do
    it "returns an xml representation including all declared elements" do
      export = described_class.new(
        resolution: Floorplanner::Models::Resolution.new(width: 100, height: 200),
        callback: "http://example.com",
        type: "application/pdf",
        paper_scale: 0.02,
        scaling: "constant",
        scalebar: true,
        black_white: false
      )

      expect(export.to_xml).to eq(remove_whitespace(<<-XML
        <export xmlns="http://floorplanner.com/export/request">
          <resolution>
              <width>100</width>
              <height>200</height>
          </resolution>
          <callback>http://example.com</callback>
          <type>application/pdf</type>
          <paper-scale>0.02</paper-scale>
          <scaling>constant</scaling>
          <scalebar>true</scalebar>
          <black-white>false</black-white>
        </export>
        XML
      ))
    end
  end
end
