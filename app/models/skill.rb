class Skill < ActiveRecord::Base
  belongs_to :category

  validates :title, :category, presence: true

  has_many :tasks

  def self_link
    "/api/v1/skills/#{id}"
  end
end
