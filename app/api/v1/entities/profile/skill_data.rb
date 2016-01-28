module V1::Entities::Profile
  class SkillData
    class AsNested < Grape::Entity
      expose :id, documentation: { type: "Integer", desc: "The ID of the skill" }
      expose :title, documentation: { type: "String", desc: "The title of the skill" }
    end

    class AsSearch < Grape::Entity
    end
  end
end
