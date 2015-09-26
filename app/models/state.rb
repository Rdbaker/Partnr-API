class State < ActiveRecord::Base
  belongs_to :project
  has_many :posts

  validates :name, :project, presence: true

  attr_readonly :project

  def has_put_permissions(user)
    user.class == User && self.project.has_admin_permissions(user)
  end

  def has_destroy_permissions(user)
    user.class == User && self.project.has_admin_permissions(user)
  end
end
