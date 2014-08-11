require "spec_helper"

describe Floorplanner::Resources::ProjectsResource do
  class described_class::ClientStub
    attr_reader :path_xml

    def initialize
      @path_xml = {}
    end

    def get(path)
      response(200, path)
    end

    def post(path, xml)
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
    it "should return a project with data from XML" do
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
end
