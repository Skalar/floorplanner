require "spec_helper"

describe Floorplanner::Models::Project do
  describe "#to_json" do
    let :project do
      project = Floorplanner::Models::Project.new
      project.name = "Test Floorplan"
      project.public = false
      project.floors = [
        {
          name: "Floor 1",
          level: 1,
          drawing: {remote_filename_url: "https://example1.jpg"}
        },
        {
          name: "Floor 2",
          level: 2,
          drawing: {remote_filename_url: "https://example2.jpg"}
        }
      ]

      project
    end

    it "returns a JSON representation of the project" do
      expect(project.to_json).to eq remove_whitespace(<<-JSON
        {
          "project":{
            "name":"Test Floorplan",
            "public":false,
            "floors_attributes":[
              {
                "name":"Floor 1",
                "level":1,
                "drawing_attributes":{
                  "remote_filename_url":"https://example1.jpg"
                }
              },
              {
                "name":"Floor 2",
                "level":2,
                "drawing_attributes":{
                  "remote_filename_url":"https://example2.jpg"
                }
              }
            ]
          }
        }
        JSON
      )
    end
  end
end
