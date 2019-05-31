module Floorplanner
  module Models
    class Project < Model
      element :id
      element :name
      element :description
      element :public
      element :external_identifier
      element :created_at, Time
      element :updated_at, Time
      element :project_url
      element :user_id
      complex :floors, Array[Floor]
      element :floor_count
    end

    class ProjectDocument < Model
      complex :project, Project
    end

    class ProjectsDocument < Model
      complex :projects, Array[Project]
    end
  end
end
