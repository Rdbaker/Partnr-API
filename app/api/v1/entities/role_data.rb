module V1::Entities
  class RoleData
    class AsShallow < Grape::Entity
      expose :id, documentation: { type: "Integer", desc: "The ID of the role." }
      expose :title, documentation: { type: "String", desc: "The role title." }
    end

    class AsDeep < AsShallow
      expose :user, documentation: { type: "UserData (shallow)", desc: "The user with this project role."}, using: UserData::AsShallow
      expose :project, documentation: { type: "ProjectData (shallow)", desc: "The project this role belongs to."}, using: ProjectData::AsShallow
    end
  end
end
