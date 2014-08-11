module Floorplanner
  module Models
    class Floor < Model
      element :id
      element :name
      element :level
      element :height
      element :drawing_url
      element :created_at
      element :updated_at
      complex :designs, Array[Design]
    end
  end
end
