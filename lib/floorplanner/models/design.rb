module Floorplanner
  module Models
    class Design < Model
      element :id
      element :name
      element :design_type
      element :thumb_2d_url
      element :project_id
      element :floor_id
      element :created_at
      element :updated_at
    end
  end
end
