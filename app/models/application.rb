class Application < ActiveRecord::Base
  belongs_to :user
  belongs_to :role
  belongs_to :project

  validate :project_and_role_align
  validates :status, :role, :project, :user, presence: true
  validates :user, uniqueness: { scope: :role,
                                 message: "A user can only apply to a role once." }

  enum status: { pending: 0, cancelled: 1, accepted: 2, rejected: 3}

  # does not include 'rejection'
  def has_update_permissions(user)
    user.class == User && self.user.id == user.id
  end

  def has_rejection_permissions(user)
    user.class == User &&
      self.role.project.has_admin_permissions(user)
  end

  def project_and_role_align
    if self.project.id != self.role.project.id
      errors.add(:project, "The application and role must belong to the same project")
    end
  end
end
