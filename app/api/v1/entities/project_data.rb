module V1::Entities
  class ProjectData < Grape::Entity
    expose :name, documentation: { type: "String", desc: "The project name." }
    expose :description, documentation: { type: "Integer", desc: "The project description." }
    expose :owner, documentation: { type: "Integer", desc: "The current project owner." }
    expose :creator, documentation: { type: "Integer", desc: "The project creator." }
    expose :id, documentation: { type: "Integer", desc: "The project id." }
  end
end
