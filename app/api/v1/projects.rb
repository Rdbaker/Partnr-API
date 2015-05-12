require_relative './validators/valid_user'

module V1
  class Projects < Grape::API
    helpers do
      def project_permissions(id)
        authenticated_user
        @project ||= get_record(Project, params[:id])
        error!("401 Unauthorized", 401) unless @project.has_admin_permissions current_user
      end
    end


    desc "Retrieve all the projects or the projects of the user with the ID given.", entity: Entities::ProjectData::AsShallow
    params do
      optional :owner, type: Integer, allow_blank: false, desc: "The User ID for the projects to retrieve."
      optional :per_page, type: Integer, default: 10, allow_blank: false, desc: "The number of projects per page."
      optional :page, type: Integer, default: 1, allow_blank: false, desc: "The page number of projects."
    end
    get do
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
      requires :name, type: String, allow_blank: false, desc: "The Project's name."
      optional :description, type: String, allow_blank: false, desc: "The Project's description."
      requires :owner, type: Integer, allow_blank: false, valid_user: true, desc: "The Project's owner's ID."
    end
    post do
      authenticated_user
      project = Project.create!({
        name: params[:name],
        description: params[:description],
        owner: params[:owner],
        creator: current_user.id
      })
      present project, with: Entities::ProjectData::AsShallow
    end


    desc "Update a project.", entity: Entities::ProjectData::AsShallow
    params do
      requires :id, type: Integer, allow_blank: false, desc: "The Project ID."
      optional :name, type: String, allow_blank: false, desc: "The Project's name."
      optional :description, type: String, allow_blank: false, desc: "The Project's description."
      optional :owner, type: Integer, allow_blank: false, valid_user: true, desc: "The Project's owner's ID."
      at_least_one_of :name, :description, :owner
    end
    put ":id" do
      project_permissions(params[:id])
      @project.update!(permitted_params params)
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
