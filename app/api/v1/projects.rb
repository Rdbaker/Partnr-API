require_relative './validators/valid_user'
require_relative './validators/valid_pagination'
require_relative './validators/length'

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


    desc "Retrieve all the projects or the projects of the user with the ID given.", entity: Entities::ProjectData::AsSearch
    params do
      optional :owner, type: Integer, allow_blank: false, desc: "The User ID for the projects to retrieve, where the user is the owner."
      optional :user, type: Integer, allow_blank: false, desc: "The User ID for the projects to retrieve, where the user has a role on the project."
      optional :status, type: String, allow_blank: false, values: ["not_started", "in_progress", "complete"], desc: "The project's status."
      optional :title, type: String, length: 1000, allow_blank: false, desc: "The title of the project."
      optional :per_page, type: Integer, default: 25, valid_per_page: [1, 100], allow_blank: false, desc: "The number of projects per page."
      optional :page, type: Integer, default: 1, allow_blank: false, desc: "The page number of projects."
    end
    get do
      if params.has_key? :status
        params[:status] = { "not_started" => 0, "in_progress" => 1, "complete" => 2 }[params[:status]]
      end

      if params.has_key? :title
        like_hash = { :title => "%#{params[:title]}%"}
        params.delete :title
      else
        like_hash = { :title => "%%" }
      end

      if params.has_key? :user
        projects = get_record(User, params[:user]).projects
        params.delete :user
      else
        projects = Project
      end

      present projects.where(permitted_params params).where("LOWER( projects.title ) LIKE :title", like_hash)
        .page(params[:page])
        .per(params[:per_page]), with: Entities::ProjectData::AsSearch
    end


    desc "Retrieve a single project.", entity: Entities::ProjectData::AsFull
    params do
      requires :id, type: Integer, allow_blank: false, desc: "The Project ID."
    end
    get ":id" do
      project = get_record(Project, params[:id])
      exp = authenticated && project.belongs_to_project(current_user) ? Entities::ProjectData::FullAsMember : Entities::ProjectData::AsFull
      present project, with: exp
    end


    desc "Create a project.", entity: Entities::ProjectData::AsFull
    params do
      requires :title, type: String, length: 1000, allow_blank: false, desc: "The Project's title."
      optional :description, type: String, length: 1000, allow_blank: false, desc: "The Project's description."
    end
    post do
      authenticated_user
      p = Project.new
      p.user_notifier = current_user
      p.update!({
        title: params[:title],
        description: params[:description],
        owner: current_user.id,
        creator: current_user.id
      })
      p.create_activity key: 'activity.project.started', owner: current_user
      present p, with: Entities::ProjectData::AsFull
    end


    desc "Update a project.", entity: Entities::ProjectData::AsFull
    params do
      requires :id, type: Integer, allow_blank: false, desc: "The Project ID."
      optional :title, type: String, length: 1000, allow_blank: false, desc: "The Project's title."
      optional :description, type: String, length: 1000, allow_blank: false, desc: "The Project's description."
      optional :owner, type: Integer, allow_blank: false, valid_user: true, desc: "The Project's owner's ID."
      optional :status, type: String, allow_blank: false, values: ["not_started", "in_progress", "complete"], desc: "The project's status."
      at_least_one_of :title, :description, :owner, :status
    end
    put ":id" do
      if !!params[:title] || !!params[:description] || !!params[:owner]
        project_permissions(params[:id])
        @project.user_notifier = current_user
        @project.update!(permitted_params params)
      elsif !!params[:status]
        project_status_permissions(params[:id])
        @project.user_notifier = current_user
        @project.status = params[:status]
        @project.save!
      end
      if @project.previous_changes.has_key?("status")
        @project.create_activity key: 'activity.project.status_change', owner: current_user
      end
      present @project, with: Entities::ProjectData::AsFull
    end


    desc "Delete a project."
    params do
      requires :id, type: Integer, allow_blank: false, desc: "The Project ID."
    end
    delete ":id" do
      project_permissions(params[:id])
      @project.user_notifier = current_user
      @project.destroy
      status 204
    end
  end
end
