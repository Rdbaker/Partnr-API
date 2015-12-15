require 'set'

class Project < Notifier
  belongs_to :user, :foreign_key => 'owner'
  has_many :roles, :dependent => :destroy
  has_many :bmarks, :dependent => :destroy
  has_many :applications, through: :roles
  has_many :users, through: :roles
  has_many :comments, :dependent => :destroy
  has_one :conversation, :dependent => :destroy

  after_create :make_conversation
  after_update :update_conversation
  after_save :update_conversation

  validates :title, :owner, :creator, :status, presence: true
  skip_callback :destroy, :before, :destroy_notification

  enum status: { not_started: 0, in_progress: 1, complete: 2 }

  attr_readonly :creator

  def has_admin_permissions(user)
    user.class == User && self.owner == user.id
  end

  def has_create_post_permissions(user)
    user.class == User && ( owner == user.id || belongs_to_project(user) )
  end

  def has_create_benchmark_permissions(user)
    has_admin_permissions user
  end

  def has_status_permissions(user)
    has_admin_permissions user
  end

  def belongs_to_project(user)
    (roles.any? { |role| role.user == user }) || user.id == owner
  end

  def followers
    Set.new(users + (comments.map { |c| c.user }) + (applications.map { |a| a.user }) + [User.find(owner)]).to_a
  end

  def self_link
    "/api/v1/projects/#{id}"
  end

  def update_conversation
    make_conversation
    self.conversation.users = Set.new(self.users + [User.find(owner)]).to_a
    self.conversation.save!
  end

  private

  def make_conversation
    if !self.conversation
      self.conversation = Conversation.new({users: users})
      self.conversation.save!
    end
  end
end
