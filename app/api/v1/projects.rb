require_relative './validators/valid_user'

module V1
  class Projects < Grape::API
    helpers do
      def get_project(id)
        project = Project.find_by(id: id)
        error!("404 Not Found", 404) if project.nil?
        project
      end

      def project_permissions(id)
        authenticated_user
        @project = get_project(params[:id])
        error!("401 Unauthorized", 401) unless @project.has_admin_permissions current_user
      end
    end


    desc "Retrieve all the projects of the current user or the projects of the user with the ID given.", entity: Entities::ProjectData
    params do
      optional :user_id, type: Integer, allow_blank: false, desc: "The User ID for the projects to retrieve."
      optional :per_page, type: Integer, default: 10, allow_blank: false, desc: "The number of projects per page."
      optional :page, type: Integer, default: 1, allow_blank: false, desc: "The page number of projects."
    end
    get do
      if !params[:user_id].nil?
        present Project.where(owner: params[:user_id])
          .page(params[:page])
          .per(params[:per_page]), with: Entities::ProjectData
      else
        present Project
          .page(params[:page])
          .per(params[:per_page]), with:Entities::ProjectData
      end
    end


    desc "Retrieve a single project.", entity: Entities::ProjectData
    params do
      requires :id, type: Integer, allow_blank: false, desc: "The Project ID."
    end
    get ":id" do
      project = get_project(params[:id])
      present project, with: Entities::ProjectData
    end


    desc "Create a project."
    params do
      requires :name, type: String, allow_blank: false, desc: "The Project's name."
      optional :description, type: String, allow_blank: false, desc: "The Project's description."
      requires :owner, type: Integer, allow_blank: false, valid_user: true, desc: "The Project's owner's ID."
    end
    post do
      authenticated_user
      project = Project.create!({
        name: params[:name],
        owner: params[:owner],
        creator: current_user.id,
        description: params[:description]
      })
      present project, with: Entities::ProjectData
    end


    desc "Update a project."
    params do
      requires :id, type: Integer, allow_blank: false, desc: "The Project ID."
      optional :name, type: String, allow_blank: false, desc: "The Project's name."
      optional :description, type: String, allow_blank: false, desc: "The Project's description."
      optional :owner, type: Integer, allow_blank: false, valid_user: true, desc: "The Project's owner's ID."
    end
    put ":id" do
      project_permissions(params[:id])
      @project.update({
        name: params[:name] || @project.name,
        description: params[:description] || @project.description,
        owner: params[:owner] || @project.owner
      })
      @project.save
      present @project, with: Entities::ProjectData
    end


    desc "Delete a project."
    params do
      requires :id, type: Integer, allow_blank: false, desc: "The Project ID."
    end
    delete ":id" do
      project_permissions(params[:id])
      @project.destroy
    end
  end
end
