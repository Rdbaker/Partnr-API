class Message < ActiveRecord::Base
  validates :sender, :content, presence: true

  belongs_to :conversation
end
