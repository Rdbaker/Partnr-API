require_relative './validators/valid_user'

module V1
  class Messages < Grape::API
    helpers do
      def get_message(id)
        message = current_user.get_conv params[:id]
        error!(404, "404 Not Found") if message.nil?
        message
      end
    end

    desc "Get the inbox of the current user."
    get do
      authenticated_user
      current_user.json_conversations
    end


    desc "Send a message."
    params do
      requires :email, type: String, allow_blank: false, desc: "The user's email to whom the message should be sent."
      requires :message, type: String, allow_blank: false, desc: "The message content."
    end
    post do
      authenticated_user
      current_user.respond_or_create_conversation(
        params[:email],
        params[:message]
      )
      current_user.json_conversations
    end


    desc "Show a specific message conversation."
    params do
      requires :id, type: Integer, allow_blank: false, desc: "The id of the message to get."
    end
    get ":id" do
      authenticated_user
      get_message(params[:id].to_i)
    end


    desc "Add a new message to a conversation."
    params do
      requires :id, type: Integer, allow_blank: false, desc: "The id of the conversation."
      requires :message, type: String, allow_blank: false, desc: "The content of the message."
    end
    put ":id" do
      authenticated_user
      current_user.reply_to_conversation(
        current_user.mailbox.conversations.find_by_id(params[:id]),
        params[:message]
      )
      current_user.get_conv(params[:id])
    end

  end
end
