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

  # return the full name of the user
  def name
    first_name + " " + last_name
  end

  def ensure_authenticaion_token
    self.authentication_token ||= generate_authentication_token
  end

protected

  def confirmation_required?
    false
  end

  def send_confirmation_notification?
    true
  end

private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end
end
