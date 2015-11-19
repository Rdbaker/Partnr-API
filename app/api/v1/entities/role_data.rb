module V1::Entities
  class RoleData
    class AsNested < Grape::Entity
      expose :id, documentation: { type: "Integer", desc: "The ID of the role." }
      expose :title, documentation: { type: "String", desc: "The role title." }
    end

    class AsChild < AsNested
      expose :user, documentation: { type: "UserData (nested)", desc: "The user with this project role."}, using: UserData::AsNested
    end

    class AsSearch < AsNested
      expose :user, documentation: { type: "UserData (nested)", desc: "The user with this project role."}, using: UserData::AsNested
      expose :project, documentation: { type: "ProjectData (nested)", desc: "The project this role belongs to."}, using: ProjectData::AsNested
    end

    class AsNotification < AsSearch
      unexpose :user
      expose :itself, as: :role do
        expose :id
        expose :title
      end
    end

    class AsFull < AsSearch
    end
  end
end
