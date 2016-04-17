class Bmark < Notifier
  include PublicActivity::Common
  
  belongs_to :project
  belongs_to :user
  has_many :posts, :dependent => :destroy
  has_many :tasks, :dependent => :nullify

  validates :title, :project, :user, presence: true
  skip_callback :destroy, :before, :destroy_notification

  attr_readonly :project, :user

  def has_put_permissions(user)
    user.class == User && self.project.has_admin_permissions(user)
  end

  def has_destroy_permissions(user)
    user.class == User && self.project.has_admin_permissions(user)
  end

  def followers
    project.followers
  end

  def self_link
    "/api/v1/milestones/#{id}"
  end
end
