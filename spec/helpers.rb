module Helpers
  def read_xml(name)
    File.read(File.join("./spec/fixtures", "#{name}.xml"))
  end
end
