module V1::Entities
  class UserData
    class AsNested < Grape::Entity
      expose :name, documentation: { type: "String", desc: "The user's full name." }
      expose :first_name, documentation: { type: "String", desc: "The user's first name." }
      expose :last_name, documentation: { type: "String", desc: "The user's last name." }
      expose :id, documentation: { type: "Integer", desc: "The user's id." }
    end

    class AsSearch < AsNested
      expose :projects, using: ProjectData::AsNested, documentation: { type: "ProjectData (shallow)",
                                                                        desc: "The projects this user is associated with.",
                                                                        is_array: true }
      expose :roles, using: RoleData::AsNested, documentation: { type: "RoleData (shallow)",
                                                                  desc: "The roles this user has on projects.",
                                                                  is_array: true }
    end

    class AsPublic < AsSearch
      expose :comments, using: CommentData::AsNested, documentation: { type: "CommentData (nested)",
                                                                        desc: "The comments user has made.",
                                                                        is_array: true }
      expose :profile, using: ProfileData::AsNested, documentation: { type: "ProfileData (nested)",
                                                                      desc: "The profile of the user"}
    end

    class AsPrivate < AsPublic
      expose :email, documentation: { type: "String", desc: "The user's email." }
      expose :authentication_token, documentation: { type: "String", desc: "The user's auth token." }
      expose :applications, using: ApplicationData::AsNested, documentation: { type: "ApplicationData (shallow)",
                                                                                desc: "The comments user has made.",
                                                                                is_array: true }
    end
  end
end
