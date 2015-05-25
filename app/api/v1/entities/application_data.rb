module V1::Entities
  class ApplicationData
    class AsShallow < Grape::Entity
      expose :status, documentation: { type: "String", desc: "The application status." }
      expose :id, documentation: { type: "Integer", desc: "The application id." }
    end

    class AsDeep < AsShallow
      expose :role, documentation: { type: "RoleData (shallow)", desc: "The role for the application." }, using: RoleData::AsShallow
      expose :user, documentation: { type: "UserData (shallow)", desc: "The applicant for the role." }, using: UserData::AsShallow
    end
  end
end
