module Floorplanner
  module Models
    class Floor < Model
      element :id
      element :name
      element :level
      element :height, Float
      element :drawing_url
      element :created_at, Time
      element :updated_at, Time
      complex :drawing, Drawing
      complex :designs, Array[Design]
    end
  end
end
