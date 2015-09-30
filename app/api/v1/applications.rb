require_relative './validators/valid_user'

module V1
  class Applications < Grape::API
    helpers do
      def application_destroy_permissions(id)
        authenticated_user
        @application ||= get_record(Application, params[:id])
        error!("401 Unauthorized", 401) unless @application.has_destroy_permissions current_user
      end

      def application_udpate_permissions(id)
        authenticated_user
        @application ||= get_record(Application, params[:id])
        error!("401 Unauthorized", 401) unless @application.has_update_permissions current_user
      end

      def application_accept_permissions(id)
        authenticated_user
        @application ||= get_record(Application, params[:id])
        error!("401 Unauthorized", 401) unless @application.has_accept_permissions current_user
      end
    end

    desc "Retrieve all applications.", entity: Entities::ApplicationData::AsShallow
    params do
      optional :user, type: Integer, allow_blank: false, desc: "The applicant's ID."
      optional :project, type: Integer, allow_blank: false, desc: "The application's project's ID."
      optional :role, type: Integer, allow_blank: false, desc: "The application's role's ID."
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
      requires :role, type: Integer, allow_blank: false, desc: "The role ID to which the application will belong."
    end
    post do
      authenticated_user
      role = Role.find_by(id: params[:role])
      error!("Role #{params[:role]} does not exist", 400) if role.nil?
      application = Application.create!({
        role: role,
        user: current_user,
        project: role.project
      })
      present application, with: Entities::ApplicationData::AsShallow
    end


    desc "Update a specific application for a role.", entity: Entities::ApplicationData::AsShallow
    params do
      requires :id, type: Integer, allow_blank: false, desc: "The appliction's ID."
      requires :status, type: String, allow_blank: false, values: ["pending", "accepted"], desc: "The application's status."
    end
    put ":id" do
      @application = get_record(Application, params[:id])
      @role = @application.role
      if params[:status] == "accepted"
        application_accept_permissions(params[:id])
        if @role.user.nil?
          @role.user = @application.user
          @application.status = "accepted"
          @role.save
          @application.save
        else
          error!("400 Bad Request: Role already has a user.", 400)
        end
      else
        # change status to 'pending'
        application_udpate_permissions(params[:id])
        if @role.user == @application.user
          @role.user = nil
          @role.save
        end
        @application.status = "pending"
        @application.save
      end
      present @application, with: Entities::ApplicationData::AsShallow
    end

    desc "Destroy an application."
    params do
      requires :id, type: Integer, allow_blank: false, desc: "The application's ID."
    end
    delete ":id" do
      application_destroy_permissions(params[:id])
      @application.destroy
      status 204
    end

  end
end
