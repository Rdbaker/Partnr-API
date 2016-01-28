class Skill < ActiveRecord::Base
  has_many :profiles
  belongs_to :category

  validates :title, :category, presence: true
end
