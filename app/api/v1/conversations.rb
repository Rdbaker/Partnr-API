require_relative './validators/valid_user'
require_relative './validators/valid_pagination'

module V1
  class Conversations < Grape::API
    helpers do
      def find_conv
        authenticate_user
        @conv = Conversation.find_by(id: params[:id])
        error!("Conversation with id #{param[:id]} was not found", 404) if @conv.nil?
        error!("User is not involved in the conversation", 401) unless @conv.users.include? current_user
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
        present proj.conversation, with: Entities::ConversationData::AsDeep
      else
        present current_user.conversations, with: Entities::ConversationData::AsSearch
      end
    end


    desc "Retrieve a single conversation for a logged in user", entity: Entities::ConversationData::AsDeep
    params do
      requires :id, type: Integer, allow_blank: false, desc: "The ID of the conversation to retrieve."
    end
    get ":id" do
      find_conv
      present @conv, with: Entities::ConversationData::AsDeep
    end


    desc "Sends a message in the conversatin or posts a new one if a conversation doesn't exist", entity: Entities::ConversationData::AsDeep
    params do
      requires :users, type: Array[Integer], allow_blank: false, desc: "The list of user IDs to send the message to.", documentation: { example: "42,87,17,6" }
      optional :message, type: String, allow_blank: false, desc: "The message to add to the conversation."
    end
    post do
      authenticated_user
      users = User.where(id: params[:users])
      convs = users.map { |user| user.conversations.to_a }
      intersection = convs.reduce { |convs_intersection, user_convs| convs_intersection & user_convs }
      if not intersection.empty?
        # add a new message
        {}
      else
        c = Conversation.new(users: users)
        c.save!
        # add a new message to the conversation from current_user
      end
    end


    desc "Sends a message to an existing conversation", entity: Entities::ConversationData::AsFull
    params do
      requires :id, type: Integer, allow_blank: false, desc: "The ID of the conversation."
      requires :message, type: String, allow_blank: false, desc: "The message to add to the conversation."
    end
    put ":id" do
      find_conv
      # add a new message to the conversation
      present @conv, with: Entities::ConversationData::AsDeep
    end
  end
end
