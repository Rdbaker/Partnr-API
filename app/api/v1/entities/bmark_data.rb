module V1::Entities
  class BmarkData
    class AsNested < Grape::Entity
      expose :id, documentation: { type: "Integer", desc: "The ID of the benchmark." }
      expose :title, documentation: { type: "String", desc: "The benchmark title." }
      expose :complete, documentation: { type: "Boolean", desc: "The benchmark's completeness." }
      expose :due_date, documentation: { type: "DateTime", desc: "The due date of the benchmark." }
      expose :created_at, documentation: { type: "String", desc: "The benchmark's create date." }
      expose :links do
        expose :self_link, documentation: { type: "URI", desc: "The link for the full benchmark entity." }, as: :self
      end
    end

    class AsSearch < AsNested
    end

    class AsFull < AsSearch
      expose :project, documentation: { type: "ProjectData (nested)", desc: "The project this benchmark belongs to." }, using: ProjectData::AsNested
      expose :user, documentation: { type: "UserData (public)", desc: "The user who created the benchmark." }, using: UserData::AsNested, as: :creator
      expose :posts, documentation: { type: "PostData (nested)", desc: "The posts on the benchmark." }, using: PostData::AsNested
    end

    class AsNotification < Grape::Entity
      expose :project, documentation: { type: "ProjectData (nested)", desc: "The project this benchmark belongs to." }, using: ProjectData::AsNested
      expose :itself, as: :benchmark do
        expose :id
        expose :title
        expose :links do
          expose :self_link, documentation: { type: "URI", desc: "The link for the full benchmark entity." }, as: :self
        end
      end
    end

  end
end
