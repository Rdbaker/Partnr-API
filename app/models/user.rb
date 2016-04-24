class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  validate :is_a_pre_approved_user
  validates :first_name, :last_name, presence: true

  has_many :roles, :dependent => :nullify
  has_many :comments, :dependent => :nullify
  has_many :bmarks, :dependent => :nullify
  has_many :tasks, :dependent => :nullify
  has_many :projects, through: :roles
  has_many :applications, :dependent => :destroy
  has_many :conversations, through: :user_conversations
  has_many :user_conversations, :dependent => :destroy
  has_many :skills, through: :tasks
  has_many :categories, through: :tasks
  has_one :profile, :dependent => :destroy
  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/img/user.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  has_many :connections, :dependent => :destroy

  before_save :ensure_authenticaion_token

  def is_a_pre_approved_user
    # during beta, you need to be a
    # pre-approved user
    if Rails.application.config.approved_users.find_index(email.downcase).nil?
      errors.add(:email, "You must be a pre-approved user to access this website")
    end
  end

  # override devise's default behavior to queue up an email instead
  # of sending it immediately
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def self_link
    "/api/v1/users/#{id}"
  end

  def gravatar_link
    "https://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email.strip.downcase)}?d=404"
  end

  def avatar_link
    link = URI avatar.url
    link.scheme = "https"
    #TODO: clean this up later
    if Rails.env.production?
      link.host = "partnr-prd-assets.s3-us-west-2.amazonaws.com"
    else
      link.host = "partnr-dev-assets.s3-us-west-2.amazonaws.com"
    end
    link.path = link.path.split('/')[2..100].join('/').prepend '/'
    link.to_s
  end

  # return the full name of the user
  def name
    first_name + " " + last_name
  end

  def ensure_authenticaion_token
    self.authentication_token ||= generate_authentication_token
  end

  def feed
    @feed ||= get_feed
  end

  def partners
    @partners ||= get_partners
  end

  def connected_users
    @connected_users ||= get_connected_users
  end

  def following
    @following ||= get_following
  end

  def follows
    @follows ||= get_follows
  end

protected

  def confirmation_required?
    false
  end

  def send_confirmation_notification?
    true
  end

private

  def get_feed
    PublicActivity::Activity.where(id: (owner_activity_query + subject_activity_query).map(&:id)).order("created_at desc")
  end

  def get_partners
    partners = projects.collect { |proj| proj.users }
    partners.flatten!
    partners.delete(self)
    partners.uniq
  end

  def get_connected_users
    connections.map { |conn| conn.other_user self }
  end

  def get_following
    follows.map { |f| f.followable }
  end

  def get_follows
    Follow.where({ user: self })
  end

  def owner_activity_query
    PublicActivity::Activity.where(["owner_id IN (?)", (partners + connected_users).uniq.map { |u| u.id }])
  end

  def subject_activity_query
    unless follows.empty?
      tupleArray = follows.map { |f| [f.followable_type, f.followable_id] }
      PublicActivity::Activity.where("(trackable_type, trackable_id) IN (#{(['(?)']*tupleArray.size).join(', ')})", *tupleArray)
    else
      []
    end
  end

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end
end
