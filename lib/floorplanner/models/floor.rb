module Floorplanner
  module Models
    class Floor < Model
      element :id
      element :name
      element :level
      element :height
      element :created_at
      element :updated_at
      complex :designs, Design
    end
  end
end
