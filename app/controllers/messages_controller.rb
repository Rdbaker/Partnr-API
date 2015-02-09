class MessagesController < ApplicationController
  # these methods should only be accessible when signed in
  before_filter :authenticate_user!
  helper_method :mailbox, :conversation
  include MessagesHelper

  # get the inbox of the user
  def index
    render :json => json_conversations(current_user)
  end

  # send a message
  def create
    recip = User.find_by(email: params[:email])
    body = params[:message]
    sender = current_user.name

    # check if a conversation already exists
    conv = conv_from_recipients([recip, current_user])

    # if it doesn't, send a new message
    if conv.nil?
      current_user.send_message(recip, body, sender)
    else
      current_user.reply_to_conversation(conv, body)
    end
    redirect_to :action => :index
  end

  # show a specific message
  def show
    res = user_conversation(current_user, params[:id])
    render :json => res
  end

  # add a message to a conversation
  def new
    message = params[:message]
    conv = current_user.mailbox.conversations.find(params[:id])
    current_user.reply_to_conversation(conv, message)
    render :json => user_conversation(current_user, params[:id])
  end
end
