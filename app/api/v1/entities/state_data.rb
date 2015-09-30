module V1::Entities
  class StateData
    class AsShallow < Grape::Entity
      expose :id, documentation: { type: "Integer", desc: "The ID of the state." }
      expose :title, documentation: { type: "String", desc: "The state title." }
      expose :project, documentation: { type: "ProjectData (shallow)", desc: "The project this state belongs to." }, using: ProjectData::AsShallow
    end

    class AsDeep < AsShallow
    end
  end
end
