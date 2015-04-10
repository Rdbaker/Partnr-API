module V1::Entities
  class UserData
    class AsPublic < Grape::Entity
      expose :first_name, documentation: { type: "String", desc: "The user's first name." }
      expose :last_name, documentation: { type: "String", desc: "The user's last name." }
      expose :id, documentation: { type: "Integer", desc: "The user's id." }
    end

    class AsPrivate < AsPublic
      expose :email, documentation: { type: "String", desc: "The user's email." }
    end
  end
end
