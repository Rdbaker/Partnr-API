class User < ActiveRecord::Base
  # allow messages to be sent
  acts_as_messageable

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
  has_many :projects, through: :roles
  has_many :applications, :dependent => :destroy
  has_one :profile, :dependent => :destroy

  before_save :ensure_authenticaion_token

  def is_a_pre_approved_user
    # if it's not prod, you need to be a
    # pre-approved user
    unless Rails.env.production?
      if Rails.application.config.approved_users.find_index(email.downcase).nil?
        errors.add(:email, "You must be a pre-approved user to access this website")
      end
    end
  end

  # override devise's default behavior to queue up an email instead
  # of sending it immediately
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  # return the full name of the user
  def name
    first_name + " " + last_name
  end

  def mailboxer_email(obj)
    email
  end

  def ensure_authenticaion_token
    self.authentication_token ||= generate_authentication_token
  end

  def json_conversations
    json_convs = []
    mailbox.conversations.all.each do |c|
      parts = []
      participants = c.recipients
      participants.delete self
      participants.each do |p|
        parts.push({ "name"=>p.name, "email"=>p.email })
      end
      json_convs.push({"participants"=>parts, "id"=>c.id})
    end
    json_convs
  end

  def respond_or_create_conversation(email, body)
    recip = User.find_by(email: email)
    unless recip.nil?
      conv = get_conv_between_user(recip)
      if conv.nil?
        send_message(recip, body, name)
      else
        reply_to_conversation(conv, body)
      end
    end
  end

  # gets a conversation given its id
  def get_conv(conv_id)
    if conv_id.class != Fixnum
      return nil
    else
      msg = mailbox.conversations.find_by_id(conv_id)
      if !msg
        return nil
      else
        receipts = msg.receipts_for self
        messages = []
        receipts.each do |m|
          messages.push Hash["message" => m.message.body, "sender" => m.message.sender.name]
        end
        messages.reverse
      end
    end
  end

protected

  def confirmation_required?
    false
  end

private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end

  def get_conv_between_user(user)
    if !(user.class == User)
      nil
    else
      convs = mailbox.conversations
      s = [self, user].sort
      convs.select{ |c| c.recipients.sort == s }[0]
    end
  end
end
