class Task < Notifier
  belongs_to :project
  has_and_belongs_to_many :users
  belongs_to :bmark

  validates :title, :project, :status, presence: true

  enum status: { not_started: 0, in_progress: 1, complete: 2 }

  def has_create_permissions(user)
    project.belongs_to_project user
  end

  def has_put_permissions(user)
    has_create_permissions user
  end

  def has_destroy_permissions(user)
    has_create_permissions user
  end

  def followers
    project.users
  end

  def self_link
    "/api/v1/tasks/#{id}"
  end
end
