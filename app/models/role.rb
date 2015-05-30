class Role < ActiveRecord::Base
  has_many :applications
  belongs_to :project
  belongs_to :user

  validates :title, :project, presence: true

  attr_readonly :project

  def has_put_permissions(user)
    user.class == User && ( self.user == user ||
      self.project.has_admin_permissions(user))
  end

  def has_destroy_permissions(user)
    user.class == User &&
      self.project.has_admin_permissions(user)
  end

end
