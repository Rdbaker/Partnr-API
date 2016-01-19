require_relative './validators/valid_user'
require_relative './validators/valid_pagination'
require_relative './validators/length'

module V1
  class Conversations < Grape::API
    helpers do
      def find_conv
        authenticated_user
        @conv = Conversation.find_by(id: params[:id])
        error!("Conversation with id #{param[:id]} was not found", 404) if @conv.nil?
        error!("User is not involved in the conversation", 401) unless @conv.users.include? current_user
      end

      def find_is_read(conv_id)
        current_user.user_conversations.find_by(conversation_id: conv_id).is_read || false
      end
    end

    desc "Retrieve all conversations for the logged in user", entity: Entities::ConversationData::AsShallow
    params do
      optional :project, type: Integer, allow_blank: false, desc: "The ID of the project for which to get the conversation."
    end
    get do
      authenticated_user
      if params.has_key? :project
        proj = Project.find_by(id: params[:project])
        error!("The project with id #{params[:project]} was not found", 404) if proj.nil?
        error!("You are not a part of this project", 401) unless proj.belongs_to_project current_user
        return {} if proj.conversation.nil?
        present proj.conversation, with: Entities::ConversationData::AsDeep, is_read: find_is_read(proj.conversation.id)
      else
        present current_user.conversations, with: Entities::ConversationData::AsSearch, user_convs: current_user.user_conversations
      end
    end


    desc "Retrieve a single conversation for a logged in user", entity: Entities::ConversationData::AsDeep
    params do
      requires :id, type: Integer, allow_blank: false, desc: "The ID of the conversation to retrieve."
    end
    get ":id" do
      find_conv
      present @conv, with: Entities::ConversationData::AsDeep, is_read: find_is_read(@conv.id)
    end


    desc "Sends a message in the conversation or posts a new one if a conversation doesn't exist", entity: Entities::MessageData::AsShallow
    params do
      requires :users, type: Array[Integer], allow_blank: false, desc: "The list of user IDs to send the message to.", documentation: { example: "42,87,17,6" }
      optional :message, type: String, length: 1000, allow_blank: false, desc: "The message to add to the conversation."
    end
    post do
      authenticated_user
      users = Set.new(User.where(id: params[:users]) + [current_user])
      if users.length <= 1
        error!("You can't start a conversation between less than 2 users!", 400)
      end
      convs = users.map { |user| user.conversations.to_a }
      intersection = convs.reduce { |convs_intersection, user_convs| convs_intersection & user_convs }
      if not intersection.empty?
        c = intersection[0]
      else
        users = users.to_a
        c = Conversation.new(users: users)
        c.save!
      end
      if params[:message]
        m = Message.new({
          user: current_user,
          body: params[:message],
          conversation: intersection[0]
        })
        m.save!
      end
      present m, with: Entities::MessageData::AsNested
    end


    desc "Sends a message to an existing conversation", entity: Entities::MessageData::AsNested
    params do
      requires :id, type: Integer, allow_blank: false, desc: "The ID of the conversation."
      optional :message, type: String, length: 1000, allow_blank: false, desc: "The message to add to the conversation."
      optional :is_read, type: Boolean
    end
    put ":id" do
      find_conv

      if params.has_key? :is_read
        ucon = @conv.user_conversations.find_by(user_id: current_user.id)
        ucon.is_read = params[:is_read]
        ucon.save!
      end

      if params.has_key? :message
        # add a new message to the conversation
        m = Message.create!({
          user: current_user,
          body: params[:message],
          conversation: @conv
        })
        @conv.user_conversations.each do |uconv|
          if uconv.user_id == current_user.id
            uconv.is_read = true
          else
            uconv.is_read = false
          end
          uconv.save!
        end
      end
      present m, with: Entities::MessageData::AsNested
    end


    desc "Deletes a message from an existing conversation", entity: Entities::ConversationData::AsFull
    params do
      requires :id, type: Integer, allow_blank: false, desc: "The ID of the message."
    end
    delete ":id" do
      authenticated_user
      msg = Message.find_by(id: params[:id])
      error!("No message could be found with that ID.", 404) if msg.nil?
      error!("You can only delete messages you sent.", 401) unless msg.user == current_user
      conv = msg.conversation
      msg.destroy!
      present conv, with: Entities::ConversationData::AsDeep, is_read: find_is_read(conv.id)
    end
  end
end
