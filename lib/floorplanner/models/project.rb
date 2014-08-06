module Floorplanner
  module Models
    class Project < Model
      element :id
      element :name
      element :description
      element :public
      element :external_identifier
      element :created_at
      element :updated_at
      element :project_url
      element :user_id
      element :location
      complex :floors, Array[Floor]
    end

    class ProjectDocument < Model
      complex :project, Project
    end

    class ProjectsDocument < Model
      complex :projects, Array[Project]
    end
  end
end
