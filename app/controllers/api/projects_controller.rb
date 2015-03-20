class Api::ProjectsController < APIController
  # these methods should only be accessible when signed in
  before_filter :authenticate_user!
  before_action :get_project_from_id, only: [:show, :update, :destroy]

  # get the user's projects
  def index
    # for now let's just do projects that this user owns
    render :json => current_user.projects
  end

  # create a new project
  def create
    @project = Project.new(project_params)
    @project.save
    redirect_to :action => :index
  end

  # show a specific project
  def show
    render :json => @project.to_json
  end

  # edit an existing project
  def update
    if @project.has_admin_permissions(current_user)
      if @project.update(project_params)
        redirect_to @project
      else
        render :json => @project.errors
      end
    else
      render :json => incorrect_permissions, status: 401
    end
  end

  # delete an existing project
  def destroy
    if @project.has_admin_permissions(current_user)
      @project.destroy
      redirect_to :action => :index
    else
      render :json => incorrect_permissions, status: 401
    end
  end

  private

  def project_params
    params.require(:project).permit(:name, :owner, :creator)
  end

  def get_project_from_id
    @project = Project.find(params[:id])
  end

  def incorrect_permissions
    {
      'error' => "You don't have the permissions to do that",
      'status' => 401
    }
  end
end
