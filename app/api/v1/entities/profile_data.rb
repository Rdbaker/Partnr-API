module V1::Entities
  class ProfileData
    class AsNested < Grape::Entity
      expose :id, documentation: { type: "Integer", desc: "The ID of the profile" }
      expose :location, using: Profile::LocationData::AsNested, documentation: { type: "LocationData (nested)",
                                                                                 desc: "The location of the user" }
      expose :school_infos, using: Profile::SchoolInfoData::AsNested, documentation: { type: "SchoolInfoData (nested)",
                                                                                       desc: "The schooling of the user",
                                                                                       is_array: true }
      expose :positions, using: Profile::PositionData::AsNested, documentation: { type: "PositionData (nested)",
                                                                                  desc: "The positions of the user",
                                                                                  is_array: true }
      expose :interests, using: Profile::InterestData::AsNested, documentation: { type: "InterestData (nested)",
                                                                                  desc: "The interests of the user",
                                                                                  is_array: true }
      expose :links do
        expose :self_link, documentation: { type: "URI", desc: "The link for the full skill entity." }, as: :self
      end
    end

    class AsFull < AsNested
      expose :skills, using: SkillData::AsSearch, documentation: { type: "SkillData (search)",
                                                                   desc: "The skills connected to the user through tasks",
                                                                   is_array: true }
      expose :categories, using: CategoryData::AsSearch, documentation: { type: "CategoryData (search)",
                                                                          desc: "The categories connected to the user through tasks",
                                                                          is_array: true }
    end
  end
end
