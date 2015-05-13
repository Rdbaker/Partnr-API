require_relative './validators/valid_user'

module V1
  class Applications < Grape::API
    helpers do
    end

    desc "Retrieve all applications.", entity: Entities::ApplicationData::AsShallow
    params do
      optional :user_id, type: Integer, allow_blank: false, desc: "The applicant's ID."
      optional :project_id, type: Integer, allow_blank: false, desc: "The application's project's ID."
      optional :role_id, type: Integer, allow_blank: false, desc: "The application's role's ID."
      optional :status, type: String, allow_blank: false, values: ["pending", "rejected", "accepted", "cancelled"], desc: "The application's status."
      optional :per_page, type: Integer, default: 10, allow_blank: false, desc: "The number of roles per page."
      optional :page, type: Integer, default: 1, allow_blank: false, desc: "The page number of the roles."
    end
    get do
      present Application.where(permitted_params params)
        .page(params[:page])
        .per(params[:per_page]), with: Entities::ApplicationData::AsShallow
    end

    desc "Get a single application based on its ID.", entity: Entities::ApplicationData::AsDeep
    params do
      requires :id, type: Integer, allow_blank: false, desc: "The application ID."
    end
    get ":id" do
      application = get_record(Application, params[:id])
      present application, with: Entities::ApplicationData::AsDeep
    end

    desc "Create a new application for a role.", entity: Entities::ApplicationData::AsShallow
    params do
      requires :role_id, type: Integer, allow_blank: false, desc: "The role to which the application will belong."
    end
    post do
      authenticated_user
      role = get_record(Role, params[:role_id])
      application = Application.create!({
        role: role,
        user: current_user,
        project: role.project
      })
      present application, with: Entities::ApplicationData::AsShallow
    end

    desc "Update a specific application for a role.", entity: Entities::ApplicationData::AsShallow
    params do
    end
    put ":id" do
    end
  end
end
