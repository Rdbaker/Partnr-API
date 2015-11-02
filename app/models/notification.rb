class Notification < ActiveRecord::Base
  belongs_to :actor, :class_name => "User", :foreign_key => "actor_id"
  belongs_to :notify, :class_name => "User", :foreign_key => "notify_id"
  belongs_to :notifier, polymorphic: true

  validates :actor, :notify, :notifier, :action, presence: true

  enum action: { created: 0, updated: 1, deleted: 2 }

  attr_readonly :actor, :notify, :notifier, :action, :is_read

  def read?
    is_read
  end

  def unread?
    not read?
  end

  def message
    I18n.t "notification.#{notifier.class}.#{action}"
  end

  def is_notifier(user)
    user.class == User && user == notify
  end
end
