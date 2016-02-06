class Skill < ActiveRecord::Base
  belongs_to :category

  validates :title, :category, presence: true
end
