class Conversation < ActiveRecord::Base
  has_many :users, :messages
end
