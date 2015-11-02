module V1::Entities
  class PostData
    class AsNested < Grape::Entity
      expose :id, documentation: { type: "Integer", desc: "The ID of the role." }
      expose :title, documentation: { type: "String", desc: "The role title." }
    end

    class AsSearch < AsNested
      expose :content, documentation: { type: "String", desc: "The content of the post." }
    end

    class AsFull < AsSearch
      expose :user, documentation: { type: "UserData (nested)", desc: "The author of the post."}, using: UserData::AsNested
      expose :bmark, documentation: { type: "BenchmarkData (nested)", desc: "The project benchmark on which this was posted" }, using: BenchmarkData::AsNested, as: :benchmark
    end
  end
end
