module V1
  class Users < Grape::API
    helpers do
      def get_user(id)
        user = User.find(id)
        error!("404 Not Found", 404) if user.nil?
        user
      end
    end


    desc "Retrieve all the users.", entity: Entities::UserData::AsPublic
    params do
      optional :per_page, type: Integer, default: 10, allow_blank: false, desc: "The number of users per page."
      optional :page, type: Integer, default: 1, allow_blank: false, desc: "The page of the users to get."
    end
    get do
      present User
        .page(params[:page])
        .per(params[:per_page]), with: Entities::UserData::AsPublic
    end


    desc "Retrieve info for a single user.", entity: Entities::UserData::AsPublic
    params do
      requires :id, type: Integer, allow_blank: false, desc: "The users's ID."
    end
    get ":id" do
      user = get_user(params[:id])
      if authenticated && current_user.id == params[:id]
        present user, with: Entities::UserData::AsPrivate
      else
        present user, with: Entities::UserData::AsPublic
      end
    end

  end
end
