module V1::Entities
  class ProjectData
    class AsNested < Grape::Entity
      expose :title, documentation: { type: "String", desc: "The project title." }
      expose :description, documentation: { type: "Integer", desc: "The project description." }
      expose :status, documentation: { type: "String", desc: "The project status." }
      expose :id, documentation: { type: "Integer", desc: "The project id." }
    end

    class AsSearch < AsNested
      expose :comments, documentation: { type: "CommentData (nested)", desc: "The comments on the project." }, using: CommentData::AsNested
      expose :users, documentation: { type: "UserData (nested)", desc: "The users working on the project." }, using: UserData::AsNested
    end

    class AsFull < AsSearch
      expose :user, documentation: { type: "UserData (nested)", desc: "The project owner." }, using: UserData::AsNested, as: :owner
      expose :applications, documentation: { type: "ApplicationData (nested)", desc: "The applications for all roles on the project." }, using: ApplicationData::AsNested
      expose :roles, documentation: { type: "RoleData (nested)", desc: "The roles for the project." }, using: RoleData::AsChild
      expose :bmarks, documentation: { type: "BenchmarkData (nested)", desc: "The benchmarks for the project." }, using: BmarkData::AsNested, as: :benchmarks
      expose :creator, documentation: { type: "Integer", desc: "The project creator's id." }
    end

    class AsNotification < AsNested
      expose :itself, as: :project do
        expose :title
        expose :id
      end
    end
  end
end
