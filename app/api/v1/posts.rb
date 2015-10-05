require_relative './validators/valid_user'
require_relative './validators/valid_pagination'

module V1
  class Posts < Grape::API
    helpers do
      def post_put_permissions(id)
        authenticated_user
        @post ||= get_record(Post, id)
        error!("401 Unauthorized", 401) unless @post.has_put_permissions current_user
      end

      def post_destroy_permissions(id)
        authenticated_user
        @post ||= get_record(Post, id)
        error!("401 Unauthorized", 401) unless @post.has_destroy_permissions current_user
      end

      def post_create_permissions(proj_id)
        authenticated_user
        @proj ||= get_record(Project, proj_id)
        error!("401 Unauthorized", 401) unless @proj.has_create_post_permissions current_user
      end
    end

    desc "Retrieve all posts for a given state.", entity: Entities::PostData::AsShallow
    params do
      requires :state, type: Integer, allow_blank: false, desc: "The state id to which the post was posted."
      optional :user, type: Integer, allow_blank: false, desc: "The author's User ID for the posts to retrieve."
      optional :title, type: String, desc: "The title of the post to retrieve."
      optional :per_page, type: Integer, default: 25, valid_per_page: [1, 100], allow_blank: false, desc: "The number of posts per page."
      optional :page, type: Integer, default: 1, allow_blank: false, desc: "The page number of the posts."
    end
    get do
      present Post.where(permitted_params params)
        .page(params[:page])
        .per(params[:per_page]), with: Entities::PostData::AsShallow
    end


    desc "Get a single post based on its ID.", entity: Entities::PostData::AsDeep
    params do
      requires :id, type: Integer, allow_blank: false, desc: "The post ID."
    end
    get ":id" do
      post = get_record(Post, params[:id])
      present post, with: Entities::PostData::AsDeep
    end


    desc "Create a new post for a state in a project.", entity: Entities::PostData::AsShallow
    params do
      requires :title, type: String, allow_blank: false, desc: "The post title."
      requires :content, type: String, allow_blank: false, desc: "The post content."
      requires :state, type: Integer, allow_blank: false, desc: "The state to which the post will belong."
    end
    post do
      authenticated_user
      state = get_record(State, params[:state])
      post_create_permissions(state.project_id)
      post = Post.create!({
        title: params[:title],
        content: params[:content],
        state: state,
        user: current_user
      })
      present post, with: Entities::PostData::AsDeep
    end


    desc "Update a specific post in a state.", entity: Entities::PostData::AsDeep
    params do
      requires :id, type: Integer, allow_blank: false, desc: "The post ID."
      optional :title, type: String, allow_blank: false, desc: "The post title."
      optional :content, type: String, allow_blank: false, desc: "The content of the post."
      at_least_one_of :title, :content
    end
    put ":id" do
      post_put_permissions(params[:id])

      if !!params[:content]
        @post.content = params[:content]
      end

      if !!params[:title]
        @post.title = params[:title]
      end

      @post.save
      present @post, with: Entities::PostData::AsDeep
    end


    desc "Delete a post in a state."
    params do
      requires :id, type: Integer, allow_blank: false, desc: "The post ID."
    end
    delete ":id" do
      post_destroy_permissions(params[:id])
      @post.destroy
      status 204
    end

  end
end
