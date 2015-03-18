class MessagesController < ApplicationController
  # these methods should only be accessible when signed in
  before_filter :authenticate_user!
  helper_method :mailbox, :conversation
  include MessagesHelper

  # get the inbox of the user
  def index
    render :json => current_user.json_conversations
  end

  # send a message
  def create
    current_user.respond_or_create_conversation(
      params[:email],
      params[:message]
    )
    redirect_to :action => :index
  end

  # show a specific message
  def show
    res = current_user.get_conv params[:id].to_i
    render :json => res
  end

  # add a message to a conversation
  def new
    current_user.reply_to_conversation current_user.mailbox.conversations.find_by_id(params[:id]), params[:message]
    render :json => current_user.get_conv(params[:id])
  end
end
