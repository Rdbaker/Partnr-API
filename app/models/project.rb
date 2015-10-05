class Project < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :roles
  has_many :applications, through: :roles

  validates :title, :owner, :creator, :status, presence: true

  enum status: { not_started: 0, in_progress: 1, complete: 2 }

  attr_readonly :creator

  def has_admin_permissions(user)
    user.class == User && self.owner == user.id
  end

  def has_create_post_permissions(user)
    user.class == User && ( owner == user.id || belongs_to_project(user) )
  end

  def has_create_state_permissions(user)
    has_create_post_permissions user
  end

  def has_status_permissions(user)
    has_admin_permissions user
  end

  def belongs_to_project(user)
    roles.any? { |role| role.user == user }
  end
end
