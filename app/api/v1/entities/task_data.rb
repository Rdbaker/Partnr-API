module V1::Entities
  class TaskData
    class AsChild < Grape::Entity
      expose :title, documentation: { type: "String", desc: "The task title." }
      expose :description, documentation: { type: "Integer", desc: "The task description." }
      expose :status, documentation: { type: "String", desc: "The task status." }
      expose :id, documentation: { type: "Integer", desc: "The task id." }
      expose :created_at, documentation: { type: "Integer", desc: "Whent the task was created." }
      expose :users, documentation: { type: "UserData (nested)", desc: "The users working on the task." }, using: UserData::AsNested
      expose :project, documentation: { type: "ProjectData (nested)", desc: "The project this task belongs to." }, using: ProjectData::AsNested
      expose :bmark, documentation: { type: "MilestoneData (nested)", desc: "The milestone this task belongs to." }, using: BmarkData::AsNested
      expose :links do
        expose :self_link, documentation: { type: "URI", desc: "The link for the full task entity." }, as: :self
      end
    end

    class AsSearch < AsChild
    end

    class AsNested < AsChild
      # migrate to using AsChild instead
    end

    class AsFull < AsChild
    end
  end
end