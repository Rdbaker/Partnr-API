module V1::Entities
  class ProjectData
    class AsShallow < Grape::Entity
      expose :title, documentation: { type: "String", desc: "The project title." }
      expose :description, documentation: { type: "Integer", desc: "The project description." }
      expose :status, documentation: { type: "String", desc: "The project status." }
      expose :id, documentation: { type: "Integer", desc: "The project id." }
    end

    class AsDeep < AsShallow
      expose :comments, documentation: { type: "CommentData (shallow)", desc: "The comments on the project." }, using: CommentData::AsShallow
      expose :user, documentation: { type: "UserData (shallow)", desc: "The project owner." }, using: UserData::AsShallow, as: :owner
      expose :applications, documentation: { type: "ApplicationData (shallow)", desc: "The applications for all roles on the project." }, using: ApplicationData::AsShallow
      expose :roles, documentation: { type: "RoleData (shallow)", desc: "The roles for the project." }, using: RoleData::AsShallow
      expose :bmarks, documentation: { type: "BenchmarkData (shallow)", desc: "The benchmarks for the project." }, using: BenchmarkData::AsShallow, as: :benchmarks
      expose :creator, documentation: { type: "Integer", desc: "The project creator's id." }
    end
  end
end
