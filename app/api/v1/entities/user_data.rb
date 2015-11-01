module V1::Entities
  class UserData
    class AsShallow < Grape::Entity
      expose :name, documentation: { type: "String", desc: "The user's full name." }
      expose :first_name, documentation: { type: "String", desc: "The user's first name." }
      expose :last_name, documentation: { type: "String", desc: "The user's last name." }
      expose :id, documentation: { type: "Integer", desc: "The user's id." }
    end

    class AsPublic < AsShallow
      expose :roles, using: RoleData::AsShallow, documentation: { type: "RoleData (shallow)",
                                                                  desc: "The roles this user has on projects.",
                                                                  is_array: true }
      expose :projects, using: ProjectData::AsShallow, documentation: { type: "ProjectData (shallow)",
                                                                        desc: "The projects this user is associated with.",
                                                                        is_array: true }
    end

    class AsPrivate < AsPublic
      expose :email, documentation: { type: "String", desc: "The user's email." }
      expose :authentication_token, documentation: { type: "String", desc: "The user's auth token." }
      expose :comments, using: CommentData::AsShallow, documentation: { type: "CommentData (shallow)",
                                                                        desc: "The comments user has made.",
                                                                        is_array: true }
    end
  end
end
