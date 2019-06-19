module Floorplanner
  module Models
    class Project < Model
      element :id, Integer
      element :name
      element :description
      element :public
      element :external_identifier
      element :created_at, Time
      element :updated_at, Time
      element :project_url
      element :user_id
      complex :project_template, Template
      complex :floors, Array[Floor]
      element :floor_count
    end

    class ProjectDocument < Model
      complex :project, Project

      def self.from_json(json_str)
        super json_str, :project
      end
    end

    class ProjectsDocument < Model
      complex :projects, Array[Project]

      def self.from_json(json_str)
        super(json_str, :projects)
      end
    end
  end
end
