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
      expose :categories, using: CategoryData::AsNested, documentation: { type: "CategoryData (nested)",
                                                                          desc: "The categories of the user's tasks and skills",
                                                                          is_array: true }
    end

    class AsFull < AsNested
    end
  end
end
