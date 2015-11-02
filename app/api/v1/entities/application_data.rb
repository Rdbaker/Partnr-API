module V1::Entities
  class ApplicationData
    class AsNested < Grape::Entity
      expose :status, documentation: { type: "String", desc: "The application status." }
      expose :id, documentation: { type: "Integer", desc: "The application id." }
    end

    class AsSearch < AsNested
      expose :role, documentation: { type: "RoleData (nested)", desc: "The role for the application." }, using: RoleData::AsNested
      expose :user, documentation: { type: "UserData (nested)", desc: "The applicant for the role." }, using: UserData::AsNested
    end

    class AsFull < AsSearch
    end
  end
end
