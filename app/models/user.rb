class User < ActiveRecord::Base
  # allow messages to be sent
  acts_as_messageable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # return the full name of the user
  def name
    first_name + " " + last_name
  end

  def mailboxer_email(obj)
    email
  end
end
