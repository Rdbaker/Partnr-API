class Bmark < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  has_many :posts, :dependent => :delete_all

  validates :title, :project, :user, presence: true

  attr_readonly :project, :user

  def has_put_permissions(user)
    user.class == User && self.project.has_admin_permissions(user)
  end

  def has_destroy_permissions(user)
    user.class == User && self.project.has_admin_permissions(user)
  end
end
