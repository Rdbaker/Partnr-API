module V1::Entities
  class PostData
    class AsShallow < Grape::Entity
      expose :id, documentation: { type: "Integer", desc: "The ID of the role." }
      expose :title, documentation: { type: "String", desc: "The role title." }
    end

    class AsDeep < AsShallow
      expose :user, documentation: { type: "UserData (shallow)", desc: "The author of the post."}, using: UserData::AsShallow
      expose :content, documentation: { type: "String", desc: "The content of the post." }
      expose :bmark, documentation: { type: "BenchmarkData (shallow)", desc: "The project benchmark on which this was posted" }, using: BenchmarkData::AsShallow, as: :benchmark
    end
  end
end
