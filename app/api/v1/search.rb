require_relative './validators/valid_user'
require_relative './validators/valid_pagination'

module V1
  class Search < Grape::API
    helpers do
      def allowed_entities
        [
          "Role",       # search for a role by the title of it
          "Project",    # search for a project by its title
          "User",       # search for a user by the full name
          "Skills"      # search for a skill by its name
        ]
      end
    end


    desc "Search for an entity or two", entity: Entities::SearchData::AsFull
    params do
      optional :entities, type: Array[String], allow_blank: false, desc: "An array of class names to search for"
      requires :query, type: String, length: 255, desc: "The string to use for searching."
    end
    get do
      search = {
        :roles => [Role.first],
        :projects => [Project.first],
        :users => [User.first],
        :skills => [Skill.first],
      }

      present search, with: Entities::SearchData::AsFull
    end
  end
end
