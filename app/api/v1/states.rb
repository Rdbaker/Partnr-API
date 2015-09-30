require_relative './validators/valid_user'

module V1
  class States < Grape::API
    helpers do
      def state_put_permissions(id)
        authenticated_user
        @state ||= get_record(State, id)
        error!("401 Unauthorized", 401) unless @state.has_put_permissions current_user
      end

      def state_destroy_permissions(id)
          authenticated_user
          @state ||= get_record(State, id)
          error!("401 Unauthorized", 401) unless @state.has_destroy_permissions current_user
      end
    end


    desc "Retrieve all states for a project", entity: Entities::StateData::AsShallow
    params do
      requires :project, type: Integer, allow_blank: false, desc: "The Project ID for the states to retreive."
      optional :name, type: String, desc: "The name of the project state to retrieve."
      optional :per_page, type: Integer, default: 10, allow_blank: false, desc: "The number of states per page."
      optional :page, type: Integer, default: 1, allow_blank: false, desc: "The page number of the states."
    end
    get do
      present State.where(permitted_params params)
        .page(params[:page])
        .per(params[:per_page]), with: Entities::StateData::AsShallow
    end


    desc "Get a single state based on its ID.", entity: Entities::StateData::AsDeep
    params do
      requires :id, type: Integer, allow_blank: false, desc: "The state ID."
    end
    get ":id" do
      state = get_record(State, params[:id])
      present state, with: Entities::StateData::AsDeep
    end


    desc "Create a new state for a project.", entity: Entities::StateData::AsShallow
    params do
      requires :name, type: String, allow_blank: false, desc: "The name of the state for the project."
      requires :project, type: Integer, allow_blank: false, desc: "The project ID to which the state will belong."
    end
    post do
      authenticated_user
      proj = get_record(Project, params[:project])
      if proj.has_create_state_permissions current_user
        state = State.create!({
          name: params[:name],
          project: proj
        })
        present state, with: Entities::StateData::AsShallow
      else
        error!("401 Unauthorized", 401)
      end
    end


    desc "Update a specific state for a project.", entity: Entities::RoleData::AsShallow
    params do
      requires :id, type: Integer, allow_blank: false, desc: "The state ID."
      optional :name, type: String, allow_blank: false, desc: "The state title."
      at_least_one_of :name
    end
    put ":id" do
      if !!params[:name]
        state_put_permissions(params[:id])
        @state.name = params[:name]
      end

      @state.save
      present @state, with: Entities::StateData::AsShallow
    end


    desc "Delete a state from a project."
    params do
      requires :id, type: Integer, allow_blank: false, desc: "The state's ID."
    end
    delete ":id" do
      state_destroy_permissions(params[:id])
      @state.destroy
      status 204
    end

  end
end
