module Floorplanner
  module Models
    class Drawing < Model
      element :id
      element :url
      element :content_type
      element :position
      element :size
      element :alpha, Float
      element :visible
    end
  end
end
