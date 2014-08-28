require "spec_helper"

describe Floorplanner::Models::PublishConfiguration do
  describe "#errors" do
    it "returns an empty array if there are no errors" do
      config = Floorplanner::Models::PublishConfiguration.new(path: "something")
      expect(config.errors).to be_empty
    end

    it "returns an array including 1 error message if path is nil" do
      config = Floorplanner::Models::PublishConfiguration.new(path: nil)
      expect(config.errors).to include("path is missing")
    end

    it "returns an array including 1 error message if path is an empty string" do
      config = Floorplanner::Models::PublishConfiguration.new(path: "")
      expect(config.errors).to include("path is missing")
    end
  end

  describe "#to_xml" do
    it "returns an xml representation including all declared elements" do
      config = Floorplanner::Models::PublishConfiguration.new(
        id: 123,
        path: "901of77",
        style_id: 555,
        show_furniture_and_texture_libraries: true,
        show_measurement_system: true,
        show_3d: false,
        show_dimensions: true,
        show_custom_dimensions: false,
        allow_print: false,
        allow_save_by_mail: true,
        show_sidebar: true,
        cc_addresses: "foo@bar.com,bar@example.com",
        allow_cc_addresses: true,
        receive_bcc: true,
        element_categories: "1,2,3,4",
        init_module: "details",
        hide_scale_bar: true
      )

      expect(config.to_xml).to eq(remove_whitespace(<<-XML
        <publish-configuration>
            <path>901of77</path>
            <style-id>555</style-id>
            <show-furniture-and-texture-libraries>true</show-furniture-and-texture-libraries>
            <show-measurement-system>true</show-measurement-system>
            <show-3d>false</show-3d>
            <show-dimensions>true</show-dimensions>
            <show-custom-dimensions>false</show-custom-dimensions>
            <allow-print>false</allow-print>
            <allow-save-by-mail>true</allow-save-by-mail>
            <show-sidebar>true</show-sidebar>
            <cc-addresses>foo@bar.com,bar@example.com</cc-addresses>
            <allow-cc-addresses>true</allow-cc-addresses>
            <receive-bcc>true</receive-bcc>
            <element-categories>1,2,3,4</element-categories>
            <init-module>details</init-module>
            <hide-scale-bar>true</hide-scale-bar>
        </publish-configuration>
        XML
      ))
    end
  end
end
