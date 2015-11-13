module Profile
  class Skill < ActiveRecord::Base
    belongs_to :profile

    validates :title, presence: true
  end
end
