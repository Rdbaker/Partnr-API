module V1::Entities
  class ConversationData
    class AsNested < Grape::Entity
    end

    class AsShallow < Grape::Entity
    end

    class AsDeep < Grape::Entity
    end

    class AsSearch < AsNested
    end

    class AsFull < AsSearch
    end
  end
end
