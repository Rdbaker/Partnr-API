module V1::Entities
  class SearchData
    class AsFull < Grape::Entity
      expose :roles, documentation: { type: "RoleData (AsSearch)", desc: "The roles that were found in the search" }, with: RoleData::AsSearch
      expose :projects, documentation: { type: "ProjectData (AsSearch)", desc: "The projects that were found from the query" }, with: ProjectData::AsSearch
      expose :users, documentation: { type: "UserData (AsSearch)", desc: "The users that were found from the query" }, with: UserData::AsSearch
      expose :skills, documentation: { type: "SkillData (AsSearch)", desc: "The skills that were found from the query" }, with: SkillData::AsSearch
    end
  end
end
