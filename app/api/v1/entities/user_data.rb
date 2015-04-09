module V1::Entities
  class UserData
    class AsPrivate < Grape::Entity
      expose :first_name, documentation: { type: "String", desc: "The user's first name." }
      expose :last_name, documentation: { type: "String", desc: "The user's last name." }
      expose :email, documentation: { type: "String", desc: "The user's email." }
      expose :id, documentation: { type: "Integer", desc: "The user's id." }
    end

    class AsPublic < AsPrivate
      unexpose :email
    end
  end
end
