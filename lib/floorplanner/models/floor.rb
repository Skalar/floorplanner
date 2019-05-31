module Floorplanner
  module Models
    class Floor < Model
      element :id
      element :name
      element :level
      element :height, Float
      element :created_at, Time
      element :updated_at, Time
      complex :drawing, Drawing
    end
  end
end
