require_relative './validators/valid_user'
require_relative './validators/valid_pagination'

module V1
  class Projects < Grape::API
    helpers do
      def project_permissions(id)
        authenticated_user
        @project ||= get_record(Project, params[:id])
        error!("401 Unauthorized", 401) unless @project.has_admin_permissions current_user
      end

      def project_status_permissions(id)
        authenticated_user
        @project ||= get_record(Project, params[:id])
        error!("401 Unauthorized", 401) unless @project.has_status_permissions current_user
      end
    end


    desc "Retrieve all the projects or the projects of the user with the ID given.", entity: Entities::ProjectData::AsShallow
    params do
      optional :owner, type: Integer, allow_blank: false, desc: "The User ID for the projects to retrieve."
      optional :status, type: String, allow_blank: false, values: ["not_started", "in_progress", "complete"], desc: "The project's status."
      optional :per_page, type: Integer, default: 25, valid_per_page: [1, 100], allow_blank: false, desc: "The number of projects per page."
      optional :page, type: Integer, default: 1, allow_blank: false, desc: "The page number of projects."
    end
    get do
      if !!params[:status]
        params[:status] = { "not_started" => 0, "in_progress" => 1, "complete" => 2 }[params[:status]]
      end

      present Project.where(permitted_params params)
        .page(params[:page])
        .per(params[:per_page]), with: Entities::ProjectData::AsShallow
    end


    desc "Retrieve a single project.", entity: Entities::ProjectData::AsDeep
    params do
      requires :id, type: Integer, allow_blank: false, desc: "The Project ID."
    end
    get ":id" do
      project = get_record(Project, params[:id])
      present project, with: Entities::ProjectData::AsDeep
    end


    desc "Create a project.", entity: Entities::ProjectData::AsShallow
    params do
      requires :title, type: String, allow_blank: false, desc: "The Project's title."
      optional :description, type: String, allow_blank: false, desc: "The Project's description."
    end
    post do
      authenticated_user
      project = Project.create!({
        title: params[:title],
        description: params[:description],
        owner: current_user.id,
        creator: current_user.id
      })
      present project, with: Entities::ProjectData::AsShallow
    end


    desc "Update a project.", entity: Entities::ProjectData::AsShallow
    params do
      requires :id, type: Integer, allow_blank: false, desc: "The Project ID."
      optional :title, type: String, allow_blank: false, desc: "The Project's title."
      optional :description, type: String, allow_blank: false, desc: "The Project's description."
      optional :owner, type: Integer, allow_blank: false, valid_user: true, desc: "The Project's owner's ID."
      optional :status, type: String, allow_blank: false, values: ["not_started", "in_progress", "complete"], desc: "The project's status."
      at_least_one_of :title, :description, :owner, :status
    end
    put ":id" do
      if !!params[:title] || !!params[:description] || !!params[:owner]
        project_permissions(params[:id])
        @project.update!(permitted_params params)
      elsif !!params[:status]
        project_status_permissions(params[:id])
        @project.status = params[:status]
      end
      present @project, with: Entities::ProjectData::AsShallow
    end


    desc "Delete a project."
    params do
      requires :id, type: Integer, allow_blank: false, desc: "The Project ID."
    end
    delete ":id" do
      project_permissions(params[:id])
      @project.destroy
      status 204
    end
  end
end
