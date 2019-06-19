require "spec_helper"

describe Floorplanner::Models::Project do
  describe "#to_json" do
    let :project do
      project = Floorplanner::Models::Project.new
      project.name = "Test Floorplan"
      project.public = false
      project.project_template = {template_id: 43}
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
            "project_template_attributes":{
              "template_id":43
            },
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
      project = ::Floorplanner::Models::ProjectDocument.from_json(read_json("find")).project

      expect(project.id).to eq(29261344)
      expect(project.name).to eq("Skalar test")
      expect(project.created_at.class).to eq Time
      expect(project.updated_at.class).to eq Time
      expect(project.floors.length).to eq(1)

      floor = project.floors.first
      expect(floor.id).to eq(35485287)
      expect(floor.name).to eq("Ground floor")
    end
  end

  describe "#from_xml" do
    it "returns an instance of Project" do
      project = ::Floorplanner::Models::ProjectDocument.from_xml(read_xml("exported")).project

      expect(project.id).to eq(29261344)
      expect(project.name).to eq("Skalar test")
      expect(project.created_at.class).to eq Time
      expect(project.updated_at.class).to eq Time
      expect(project.floors.length).to eq(1)

      floor = project.floors.first
      expect(floor.id).to eq(35485287)
      expect(floor.name).to eq("Ground floor")

      design = floor.designs.first
      expect(design.id).to eq(647805585)
      expect(design.name).to eq("untitled")
    end

    it "returns an instance of Project with XML exported from API version 1" do
      project = ::Floorplanner::Models::ProjectDocument.from_xml(read_xml("exported_legacy")).project

      expect(project.id).to eq(63722943)
      expect(project.name).to eq("An old project")
      expect(project.created_at.class).to eq Time
      expect(project.updated_at.class).to eq Time
      expect(project.floors.length).to eq(1)

      floor = project.floors.first
      expect(floor.id).to eq(115050306)
      expect(floor.name).to eq("Floor 0")

      design = floor.designs.first
      expect(design.id).to eq(121351764)
      expect(design.name).to eq("Floor 0")
    end
  end
end
