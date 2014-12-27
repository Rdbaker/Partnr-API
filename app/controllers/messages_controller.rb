# a message sent from one user to one (or more) users
class MessagesController < ApplicationController
  # these methods should only be accessible when signed in
  before_filter :authenticate_user!

  # send a new message
  def create
    # validate the message info
    # get a conversation based on the sender/recipient(s)
    # create a new conversation if one doesn't already exist
    # create a new message
    # add the message to the conversation
  end
end
