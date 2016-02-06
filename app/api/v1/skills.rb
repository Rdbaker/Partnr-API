require_relative './validators/length'

module V1
  class Skills < Grape::API
    helpers do
      def create_skill(title, cat)
        @skill = Skill.find_by({ title: title.downcase, category: cat })
        if @skill.nil?
          @skill = Skill.create({ title: title.downcase, category: cat })
        end
      end
    end


    desc "Search for skills.", entity: Entities::SkillData::AsSearch
    params do
      optional :title, type: String, allow_blank: false, desc: "The title of a skill."
      optional :category, type: Integer, allow_blank: false, desc: "The category of a skill"
      optional :per_page, type: Integer, default: 25, valid_per_page: [1, 100], allow_blank: false, desc: "The number of categories per page."
      optional :page, type: Integer, default: 1, allow_blank: false, desc: "The page number of the categories."
    end
    get do
      present Skill.where(permitted_params params)
        .page(params[:page])
        .per(params[:per_page]), with: Entities::SkillData::AsSearch
    end


    desc "Creates a new skill.", entity: Entities::SkillData::AsFull
    params do
      requires :title, type: String, length: 1000, allow_blank: false, desc: "The title of a new skill."
      requires :category, type: Integer, allow_blank: false, desc: "The ID of the category to which the skill belongs."
    end
    post do
      cat = get_record(Category, params[:category])
      create_skill params[:title], cat
      present @skill, with: Entities::Profile::SkillData::AsNested
    end
  end
end
