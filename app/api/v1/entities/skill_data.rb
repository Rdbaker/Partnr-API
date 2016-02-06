module V1::Entities
  class SkillData
    class AsNested < Grape::Entity
      expose :id, documentation: { type: "Integer", desc: "The ID of the skill" }
      expose :title, documentation: { type: "String", desc: "The title of the skill" }
    end

    class AsSearch < AsNested
      expose :category, documentation: { type: "CategoryData (AsNested)", desc: "The category of the skill" }, with: CategoryData::AsNested
    end

    class AsFull < AsSearch
    end
  end
end
