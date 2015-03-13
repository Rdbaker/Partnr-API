class User < ActiveRecord::Base
  # allow messages to be sent
  acts_as_messageable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validate :is_a_pre_approved_user

  has_and_belongs_to_many :projects

  def is_a_pre_approved_user
    # if it's not prod, you need to be a
    # pre-approved user
    unless Rails.env.production?
      if Rails.application.config.approved_users.find_index(email).nil?
        errors.add(:email, "You must be a pre-approved user to access this website")
      end
    end
  end

  # return the full name of the user
  def name
    first_name + " " + last_name
  end

  def mailboxer_email(obj)
    email
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
      return []
    else
      msg = mailbox.conversations.find_by_id(conv_id)
      if !msg
        return []
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

private

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
