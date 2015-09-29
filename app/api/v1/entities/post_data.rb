module V1::Entities
  class PostData
    class AsShallow < Grape::Entity
      expose :id, documentation: { type: "Integer", desc: "The ID of the role." }
      expose :title, documentation: { type: "String", desc: "The role title." }
      expose :state, documentation: { type: "StateData (shallow)", desc: "The project state on which this was posted" }, using: StateData::AsShallow
    end

    class AsDeep < AsShallow
      expose :user, documentation: { type: "UserData (shallow)", desc: "The author of the post."}, using: UserData::AsShallow
      expose :content, documentation: { type: "String", desc: "The content of the post." }
    end
  end
end
