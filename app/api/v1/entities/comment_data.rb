module V1::Entities
  class CommentData
    class AsShallow < Grape::Entity
      expose :content, documentation: { type: "String", desc: "The comment content." }
      expose :id, documentation: { type: "Integer", desc: "The comment ID." }
      expose :created_at, documentation: { type: "Time", desc: "The date and time the comment was created." }
      expose :user, documentation: { type: "UserData (shallow)", desc: "The user that made the comment." }, using: UserData::AsShallow
      expose :project, documentation: { type: "ProjectData (shallow)", desc: "The project on which the comment was made." }, using: ProjectData::AsShallow
    end
  end
end
