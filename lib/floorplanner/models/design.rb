module Floorplanner
  module Models
    class Design < Model
      element :id, Integer
      element :name
      element :project_id
      element :floor_id
    end
  end
end
