require "spec_helper"

describe Floorplanner::Resources::ProjectsResource do
  class described_class::ClientStub
    attr_reader :path_xml
    attr_reader :post_xml
    attr_reader :post_path

    def initialize
      @path_xml = {}
    end

    def get(path)
      response(200, path)
    end

    def post(path, xml)
      @post_xml = xml
      @post_path = path
      response(201, path)
    end

    private

    def response(code, path)
      HTTPI::Response.new(code, {}, path_xml[path])
    end
  end

  let(:client) { described_class::ClientStub.new }

  subject { described_class.new(client) }

  describe "#find" do
    it "should return a project with data from the response XML" do
      client.path_xml["projects/29261344.xml"] = read_xml("find")

      project = subject.find(29261344)

      expect(project.id).to be(29261344)
      expect(project.name).to eq("Skalar test")
      expect(project.public).to be(false)
      expect(project.external_identifier).to eq("ID2345")
      expect(project.created_at).to eq(Time.new(2014, 8, 8, 8, 59, 32, "-04:00"))
      expect(project.updated_at).to eq(Time.new(2014, 8, 8, 8, 59, 33, "-04:00"))
      expect(project.project_url).to eq("jz4sdc")
      expect(project.user_id).to be(26011672)
      expect(project.floors.length).to be(1)

      floor = project.floors.first

      expect(floor.id).to be(35485287)
      expect(floor.name).to eq("Ground floor")
      expect(floor.level).to be(0)
      expect(floor.height).to be(2.8)
      expect(floor.created_at).to eq(Time.new(2014, 8, 8, 8, 59, 32, "-04:00"))
      expect(floor.updated_at).to eq(Time.new(2014, 8, 8, 8, 59, 32, "-04:00"))
      expect(floor.designs).to be_empty

      drawing = floor.drawing

      expect(drawing.id).to be(1380134)
      expect(drawing.url).to eq("http://cdn.floorplanner.com/uploads/drawings/1380134/S.R._Thompson_House.jpg")
      expect(drawing.content_type).to eq("image/jpeg")
      expect(drawing.position).to eq("7.50 5.00 0.00")
      expect(drawing.size).to eq("20.00 15.00 0.00")
      expect(drawing.alpha).to eq(50.0)
      expect(drawing.visible).to eq("1")
    end
  end

  describe "#all" do
    it "returns an array of projects based on the response XML" do
      client.path_xml["projects.xml"] = read_xml("all")

      projects = subject.all

      expect(projects.length).to be(4)
      expect(projects[0].id).to be(29261344)
      expect(projects[1].id).to be(29261186)
      expect(projects[2].id).to be(29255071)
      expect(projects[3].id).to be(29253756)
    end
  end

  describe "#create" do
    it "posts a project XML to Floorplanner" do
      f = Floorplanner::Models::Floor.new
      f.name = "Ground floor"
      f.drawing_url = "http://example.com/some-image.jpg"

      p = Floorplanner::Models::Project.new
      p.name = "Portveien 2"
      p.description = "A nice little house with 2 floors"
      p.public = false
      p.external_identifier = "ID123"
      p.floors = [f]

      subject.create(p)

      expect(client.post_xml).to eq(remove_whitespace(read_xml("create")))
    end

    it "returns an instance of Floorplanner::Models::Project for the created project" do
      client.path_xml["projects.xml"] = read_xml("create_response")
      doc = Floorplanner::Models::ProjectDocument.from_xml(read_xml("create"))
      created = subject.create(doc.project)
      expect(created.class).to be(Floorplanner::Models::Project)
      expect(created.id).to be(29231859)
    end
  end

  describe "#add_collaborator" do
    it "posts a collaborator XML to Floorplanner" do
      subject.add_collaborator(123, email: "test@example.com")
      expect(client.post_path).to eq("projects/123/collaborate.xml")
      expect(client.post_xml).to eq("<email>test@example.com</email>")
    end
  end

  describe "#export" do
    it "returns the FML (xml) returned from the server" do
      xml = "<project><test>foobar</test></project>"
      client.path_xml["projects/123/export.xml"] = xml
      result = subject.export(123)
      expect(result).to eq(xml)
    end
  end

  describe "#render" do
    it "raises an error if width is nil" do
      expect { subject.render(123, width: nil, height: 500, callback: "http://example.com/foobar") }.to raise_error
    end

    it "raises an error if height is nil" do
      expect { subject.render(123, width: 500, height: nil, callback: "http://example.com/foobar") }.to raise_error
    end

    it "raises an error if both callback and send_to are missing" do
      expect { subject.render(123, width: 500, height: 500) }.to raise_error
    end

    it "raises an error if both callback and send_to are given" do
      expect { subject.render(123, width: 500, height: 500, callback: "http://foobar.com", send_to: "test@example.com") }.to raise_error
    end

    it "raises NO error if width, height and callback are given" do
      expect { subject.render(123, width: 500, height: 500, callback: "http://foobar.com") }.to_not raise_error
    end

    it "raises NO error if width, height and send_to are given" do
      expect { subject.render(123, width: 500, height: 500, send_to: "test@example.com") }.to_not raise_error
    end

    it "posts an XML request to the project render endpoint on the Floorplanner server" do
      xml = read_xml("render_request")

      subject.render(123,
        width: 500,
        height: 500,
        callback: "http://example.com/callback",
        type: "application/pdf",
        paper_scale: 0.003,
        scaling: "constant",
        scalebar: 1,
        black_white: false
      )

      expect(client.post_path).to eq("projects/123/render")
      expect(client.post_xml).to eq(remove_whitespace(xml))
    end
  end

  describe "#publish" do
    it "raises the first returned error from the publish configuration as an error" do
      config = Floorplanner::Models::PublishConfiguration.new(path: nil)
      expect { subject.publish(123, config) }.to raise_error(config.errors.first)
    end

    it "posts an XML request to the project publish configuration endpoint on the Floorplanner server" do
      config = Floorplanner::Models::PublishConfiguration.new(path: "foobar")
      subject.publish(123, config)
      expect(client.post_path).to eq("projects/123/configuration.xml")
      expect(client.post_xml).to eq(config.to_xml)
    end
  end
end
