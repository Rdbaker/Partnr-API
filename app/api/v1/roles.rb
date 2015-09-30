require_relative './validators/valid_user'

module V1
  class Roles < Grape::API
    helpers do
      def role_put_permissions(id)
        authenticated_user
        @role ||= get_record(Role, id)
        error!("401 Unauthorized", 401) unless @role.has_put_permissions current_user
      end

      def role_assign_permissions(id)
        authenticated_user
        @role ||= get_record(Role, id)
        error!("401 Unauthorized", 401) unless @role.project.has_admin_permissions current_user
      end

      def role_destroy_permissions(id)
        authenticated_user
        @role ||= get_record(Role, id)
        error!("401 Unauthorized", 401) unless @role.has_destroy_permissions current_user
      end
    end

    desc "Retrieve all roles.", entity: Entities::RoleData::AsDeep
    params do
      optional :user, type: Integer, allow_blank: false, desc: "The User ID for the roles to retrieve."
      optional :title, type: String, desc: "The title of the role to retrieve."
      optional :per_page, type: Integer, default: 10, allow_blank: false, desc: "The number of roles per page."
      optional :page, type: Integer, default: 1, allow_blank: false, desc: "The page number of the roles."
    end
    get do
      present Role.where(permitted_params params)
        .page(params[:page])
        .per(params[:per_page]), with: Entities::RoleData::AsDeep
    end


    desc "Get a single role based on its ID.", entity: Entities::RoleData::AsDeep
    params do
      requires :id, type: Integer, allow_blank: false, desc: "The role ID."
    end
    get ":id" do
      role = get_record(Role, params[:id])
      present role, with: Entities::RoleData::AsDeep
    end


    desc "Create a new role for a project.", entity: Entities::RoleData::AsShallow
    params do
      requires :title, type: String, allow_blank: false, desc: "The role title."
      requires :project, type: Integer, allow_blank: false, desc: "The project to which the role will belong."
    end
    post do
      authenticated_user
      proj = get_record(Project, params[:project])
      role = Role.create!({
        title: params[:title],
        project: proj,
        user: nil
      })
      present role, with: Entities::RoleData::AsShallow
    end


    desc "Update a specific role for a project.", entity: Entities::RoleData::AsShallow
    params do
      requires :id, type: Integer, allow_blank: false, desc: "The role ID."
      optional :title, type: String, allow_blank: false, desc: "The role title."
      optional :user, type: Integer, allow_blank: false, desc: "The user ID assigned to the role."
      at_least_one_of :title, :user
    end
    put ":id" do
      role_assign_permissions(params[:id]) if !!params[:user]
      role_put_permissions(params[:id]) if !!params[:title]

      if !!params[:user] && current_user.id == params[:user]
        role_assign_permissions params[:id]
        if current_user.id == params[:user] && @role.user.nil?
          @role.user = get_record(User, params[:user])
        else
          return error!("401 Unauthorized", 401)
        end
      end

      if !!params[:title]
        role_put_permissions params[:id]
        @role.title = params[:title]
      end

      @role.save
      present @role, with: Entities::RoleData::AsShallow
    end


    desc "Delete a role for a project."
    params do
      requires :id, type: Integer, allow_blank: false, desc: "The role ID."
    end
    delete ":id" do
      role_destroy_permissions(params[:id])
      @role.destroy
      status 204
    end

  end
end
