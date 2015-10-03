module V1::Entities
  class ProjectData
    class AsShallow < Grape::Entity
      expose :title, documentation: { type: "String", desc: "The project title." }
      expose :description, documentation: { type: "Integer", desc: "The project description." }
      expose :status, documentation: { type: "String", desc: "The project status." }
      expose :owner, documentation: { type: "Integer", desc: "The current project owner." }
      expose :creator, documentation: { type: "Integer", desc: "The project creator." }
      expose :id, documentation: { type: "Integer", desc: "The project id." }
    end

    class AsDeep < AsShallow
      expose :roles, documentation: { type: "RoleData (shallow)", desc: "The roles for the project." }, using: RoleData::AsShallow
    end
  end
end
