require_relative './validators/valid_user'
require_relative './validators/valid_pagination'

module V1
  class Comments < Grape::API
    helpers do
      def comment_put_permissions(id)
        authenticated_user
        @comment ||= get_record(Comment, id)
        error!("401 Unauthorized", 401) unless @comment.has_put_permissions current_user
      end

      def comment_destroy_permissions(id)
        authenticated_user
        @comment ||= get_record(Comment, id)
        error!("401 Unauthorized", 401) unless @comment.has_destroy_permissions current_user
      end
    end


    desc "Retrieve all comments for a given project.", entity: Entities::CommentData::AsShallow
    params do
      requires :project, type: Integer, allow_blank: false, desc: "The project ID on which the comments were made."
      optional :user, type: Integer, allow_blank: false, desc: "The author's User ID who made the comments."
      optional :per_page, type: Integer, default: 25, valid_per_page: [1, 100], allow_blank: false, desc: "The number of comments per page."
      optional :page, type: Integer, default: 1, allow_blank: false
    end
    get do
      present Comment.where(permitted_params params)
        .page(params[:page])
        .per(params[:per_page]), with: Entities::CommentData::AsShallow
    end


    desc "Get a single comment based on its ID.", entity: Entities::CommentData::AsShallow
    params do
      requires :id, type: Integer, allow_blank: false, desc: "The comment ID."
    end
    get ":id" do
      comment = get_record(Comment, params[:id])
      present comment, with: Entities::CommentData::AsShallow
    end


    desc "Create a new comment on a project.", entity: Entities::CommentData::AsShallow
    params do
      requires :content, type: String, allow_blank: false, desc: "The comment content."
      requires :project, type: Integer, allow_blank: false, desc: "The project ID for the comment."
    end
    post do
      authenticated_user
      project = get_record(Project, params[:project])
      comment = Comment.create!({
        content: params[:content],
        project: project,
        user: current_user
      })
      present comment, with: Entities::CommentData::AsShallow
    end


    desc "Update a comment on a project.", entity: Entities::CommentData::AsShallow
    params do
      requires :id, type: Integer, allow_blank: false, desc: "The comment ID."
      requires :content, type: String, allow_blank: false, desc: "The new content for the comment."
    end
    put ":id" do
      comment_put_permissions(params[:id])
      @comment.content = params[:content]
      @comment.save
      present @comment, with: Entities::CommentData::AsShallow
    end


    desc "Delete a comment on a project."
    params do
      requires :id, type: Integer, allow_blank: false, desc: "The comment ID."
    end
    delete ":id" do
      comment_destroy_permissions(params[:id])
      @comment.destroy
      status 204
    end
  end
end