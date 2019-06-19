require "spec_helper"

describe Floorplanner::Resources::ProjectsResource do
  let(:client) { described_class::ClientStub.new }

  subject { described_class.new(client) }

  describe "#find" do
    it "should return a project with data from the response JSON" do
      client.path_body["projects/29261344.json"] = read_json("find")

      project = subject.find(29261344)

      expect(project.id).to be(29261344)
      expect(project.name).to eq("Skalar test")
      expect(project.public).to be(false)
      expect(project.external_identifier).to eq("ID2345")
      expect(project.created_at).to eq(Time.new(2014, 8, 8, 8, 59, 32))
      expect(project.updated_at).to eq(Time.new(2014, 8, 8, 8, 59, 33))
      expect(project.project_url).to eq("jz4sdc")
      expect(project.user_id).to be(26011672)
      expect(project.floors.length).to be(1)

      floor = project.floors.first

      expect(floor.id).to be(35485287)
      expect(floor.name).to eq("Ground floor")
      expect(floor.level).to be(0)
      expect(floor.height).to be(2.8)
      expect(floor.created_at).to eq(Time.new(2014, 8, 8, 8, 59, 32))
      expect(floor.updated_at).to eq(Time.new(2014, 8, 8, 8, 59, 32))
    end
  end

  describe "#all" do
    it "returns an array of projects based on the response JSON" do
      client.path_body["projects.json"] = read_json("all")

      projects = subject.all

      expect(projects.length).to be(4)
      expect(projects[0].id).to be(29261344)
      expect(projects[1].id).to be(29261186)
      expect(projects[2].id).to be(29255071)
      expect(projects[3].id).to be(29253756)
    end
  end

  describe "#create" do
    it "posts a project JSON to Floorplanner" do
      p = Floorplanner::Models::Project.new
      p.name = "Portveien 2"
      p.description = "A nice little house with 1 floors"
      p.public = false
      p.external_identifier = "ID123"
      p.floors = [
        {
          name: "Ground floor",
          drawing: {
            remote_filename_url: "http://example.com/some-image.jpg"
          }
        }
      ]

      client.path_body["projects.json"] = read_json("create_response")
      subject.create(p)

      expect(client.post_data).to eq(remove_whitespace(read_json("create")))
    end

    it "returns an instance of Floorplanner::Models::Project for the created project" do
      client.path_body["projects.json"] = read_json("create_response")
      doc = Floorplanner::Models::ProjectDocument.from_json(read_json("create"))
      created = subject.create(doc.project)
      expect(created.class).to be(Floorplanner::Models::Project)
      expect(created.id).to be(29231859)
    end
  end

  describe "#delete" do
    it "deletes the project with the given id from Floorplanner" do
      subject.delete(123)
      expect(client.delete_path).to eq("projects/123.json")
    end
  end

  describe "#export" do
    it "returns the FML (xml) returned from the server" do
      xml = "<project><test>foobar</test></project>"
      client.path_body["projects/123.fml"] = xml
      result = subject.export(123)
      expect(result).to eq(xml)
    end
  end

  describe "#render_2d" do
    it "posts a JSON request to the project render2d endpoint" do
      subject.render_2d(123, callback: "http://example.com", width: 500, height: 400, combine: true, orientation: "landscape")
      expect(client.post_path).to eq("projects/123/export.json")

      json = JSON.parse(client.post_data)
      expect(json["type"]).to eq("2d")
      expect(json["callback"]).to eq("http://example.com")
      expect(json["width"]).to be(500)
      expect(json["height"]).to be(400)
      expect(json["paper"]["combine"]).to eq(true)
    end
  end

  describe "#render_3d" do
    let(:opts) {
      {
        callback: "http://example.com",
        width: 500,
        height: 400,
        view: "top",
        combine: false,
        orientation: "landscape"
      }
    }

    it "raises an error if view contains an unsupported option" do
      opts[:view] = "invalid"
      expect { subject.render_3d(123, **opts) }.to raise_error("Unsupported view type: invalid")
    end

    it "supports the view types [se sw ne nw top]" do
      %w{ se sw ne nw top }.each do |viewtype|
        opts[:view] = viewtype
        expect { subject.render_3d(123, **opts) }.not_to raise_error
      end
    end

    it "posts a JSON request to the project render3d endpoint" do
      subject.render_3d(123,
        callback: "http://example.com",
        width: 500,
        height: 400,
        view: "top",
        combine: false,
        orientation: "landscape"
      )

      expect(client.post_path).to eq("projects/123/export.json")

      json = JSON.parse(client.post_data)
      expect(json["type"]).to eq("3d")
      expect(json["callback"]).to eq("http://example.com")
      expect(json["width"]).to be(500)
      expect(json["height"]).to be(400)
      expect(json["views"].first["type"]).to eq("top")
      expect(json["paper"]["combine"]).to eq(false)
    end
  end

  describe "#publish" do
    it "posts JSON setting public to true to Floorplanner" do
      client.path_body["projects/123.json"] = read_json("update_response")
      subject.publish(123)
      expect(client.put_path).to eq("projects/123.json")
      expect(client.put_data).to eq '{"public":true}'
    end

    it "returns an instance of Floorplanner::Models::Project for the updated project" do
      client.path_body["projects/7742222.json"] = read_json("update_response")
      created = subject.publish(7742222)
      expect(created.class).to be(Floorplanner::Models::Project)
      expect(created.id).to be(7742222)
    end
  end

  describe "#unpublish" do
    it "posts JSON setting public to false to Floorplanner" do
      client.path_body["projects/123.json"] = read_json("update_response")
      subject.unpublish(123)
      expect(client.put_path).to eq("projects/123.json")
      expect(client.put_data).to eq '{"public":false}'
    end

    it "returns an instance of Floorplanner::Models::Project for the updated project" do
      client.path_body["projects/7742222.json"] = read_json("update_response")
      created = subject.unpublish(7742222)
      expect(created.class).to be(Floorplanner::Models::Project)
      expect(created.id).to be(7742222)
    end
  end

  class described_class::ClientStub
    attr_reader :path_body
    attr_reader :post_data
    attr_reader :post_path
    attr_reader :put_data
    attr_reader :put_path
    attr_reader :delete_path

    def initialize
      @path_body = {}
    end

    def get(path)
      response(200, path)
    end

    def post(path, data, content_type = "application/json")
      @post_data = data
      @post_path = path
      response(201, path)
    end

    def put(path, data, content_type = "application/json")
      @put_data = data
      @put_path = path
      response(200, path)
    end

    def delete(path)
      @delete_path = path
      response(200, path)
    end

    private

    def response(code, path)
      HTTPI::Response.new(code, {}, path_body[path])
    end
  end
end
