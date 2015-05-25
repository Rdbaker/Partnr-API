class Application < ActiveRecord::Base
  belongs_to :user
  belongs_to :role
  belongs_to :project

  validate :project_and_role_align
  validates :status, :role, :project, :user, presence: true
  validates :user, uniqueness: { scope: :role,
                                 message: "A user can only apply to a role once." }

  enum status: { pending: 0, accepted: 1 }

  def has_update_permissions(user)
    user.class == User && self.user.id == user.id
  end

  def has_destroy_permissions(user)
    user.class == User &&
      (
        self.role.project.has_admin_permissions(user) ||
        user.id == self.user.id
      )
  end

  def has_accept_permissions(user)
    user.class == User && self.project.has_admin_permissions(user)
  end

  def project_and_role_align
    if self.project.id != self.role.project.id
      errors.add(:project, "The application and role must belong to the same project")
    end
  end
end
