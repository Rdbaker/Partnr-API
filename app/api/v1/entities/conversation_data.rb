module V1::Entities
  class ConversationData
    class AsNested < Grape::Entity
      expose :id, documentation: { type: "Integer", desc: "The ID of the conversation." }
      expose :users, documentation: { type: "UserData (AsNested)", dest: "The users in the conversation", is_array: true }, using: UserData::AsNested
    end

    class AsShallow < AsNested
    end

    class AsDeep < AsShallow
      expose :messages, documentation: { type: "MessageData (AsNested)", desc: "The messages in the conversation.", is_array: true }, using: MessageData::AsNested
    end

    class AsSearch < AsNested
    end

    class AsFull < AsSearch
    end
  end
end
