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

  describe "#from_json" do
    it "returns an instance of Project" do
      project = ::Floorplanner::Models::ProjectDocument.from_json(read_json("find"), :project).project

      expect(project.id).to be(29261344)
      expect(project.name).to eq("Skalar test")
      expect(project.created_at.class).to eq Time
      expect(project.updated_at.class).to eq Time
      expect(project.floors.length).to be(1)

      floor = project.floors.first
      expect(floor.id).to be(35485287)
      expect(floor.name).to eq("Ground floor")
    end
  end

  describe "#from_xml" do
    it "returns an instance of Project" do
      project = ::Floorplanner::Models::ProjectDocument.from_xml(read_xml("exported")).project

      expect(project.id).to be(29261344)
      expect(project.name).to eq("Skalar test")
      expect(project.created_at.class).to eq Time
      expect(project.updated_at.class).to eq Time
      expect(project.floors.length).to be(1)

      floor = project.floors.first
      expect(floor.id).to be(35485287)
      expect(floor.name).to eq("Ground floor")
    end
  end
end
