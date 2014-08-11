module Helpers
  def read_xml(name)
    File.read(File.join("./spec/fixtures", "#{name}.xml")) rescue ""
  end

  def remove_whitespace(str)
    str.split(/^\s+|/).join("").split(/$\s+/).join("")
  end
end
