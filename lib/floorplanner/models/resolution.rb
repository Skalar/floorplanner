module Floorplanner
  module Models
    class Resolution < Model
      element :width # The width of the image(s) in pixels (or millimeters for PDF)
      element :height # The height of the image(s) in pixels (or millimeters for PDF)
    end
  end
end
