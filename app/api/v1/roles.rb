require_relative './validators/valid_user'

module V1
  class Roles < Grape::API
    helpers do
      def role_put_permissions(id)
        authenticated_user
        @role = get_record(Role, id)
        error!("401 Unauthorized", 401) unless @role.has_put_permissions current_user
      end

      def role_assign_permissions(id)
        authenticated_user
        @role = get_record(Role, id)
        error!("401 Unauthorized", 401) unless @role.project.has_admin_permissions current_user
      end

      def role_destroy_permissions(id)
        authenticated_user
        @role = get_record(Role, id)
        error!("401 Unauthorized", 401) unless @role.has_destroy_permissions current_user
      end
    end

    desc "Retrieve all the roles or the roles of the user with the ID given.", entity: Entities::RoleData::AsDeep
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
      requires :title, type: Integer, allow_blank: false, desc: "The role title."
      requires :project_id, type: Integer, allow_blank: false, desc: "The project to which the role will belong."
    end


  end
end
