class Bmark < Notifier
  belongs_to :project
  belongs_to :user
  has_many :posts, :dependent => :destroy

  validates :title, :project, :user, presence: true

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
    "/api/v1/benchmarks/#{id}"
  end
end
