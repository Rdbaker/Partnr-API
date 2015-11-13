require_relative './validators/valid_user'

module V1
  class Profiles < Grape::API
    helpers do
      def profile_udpate_permissions(id)
        authenticated_user
        @profile ||= get_record(Profile, id)
        error!("401 Unauthorized", 401) unless @profile.user == current_user
      end

      def profile_destroy_permissions(id)
        profile_update_permissions(id)
      end

      def profile_create
        authenticated_user
        @profile = current_user.profile || Profile.new
        @profile.user = current_user
        @profile
      end

      def create_entity(cls, params)
        cls.create!(params.merge({ :profile => @profile }))
      end

      def entity_align(entity, profile)
        error!("401 That #{entity.class} does not belong to the profile", 401) unless profile == entity.profile
      end
    end

    route_param :id do

      namespace :interests do
        desc "Creates a new interest for a profile.", entity: Entities::Profile::InterestData::AsNested
        params do
          requires :title, type: String, allow_blank: false, desc: "The title of a new interest."
        end
        post do
          profile_create
          create_entity(Interest, {title: params[:title]})
          @profile.save!
        end

        desc "Updates an existing interest.", entity: Entities::Profile::InterestData::AsNested
        params do
          requires :interest_id, type: Integer, allow_blank: false, desc: "The ID of the interest."
          requires :title, type: String, allow_blank: false, desc: "The new title of the interest."
        end
        put ":interest_id" do
          profile_udpate_permissions(params[:id])
          interest = get_record(Interest, params[:interest_id])
          entity_align(interest, @profile)
          interest.title = params[:title]
          interest.save!
        end

        desc "Destroy an existing interest.", entity: Entities::Profile::InterestData::AsNested
        params do
          requires :interest_id, type: Integer, allow_blank: false, desc: "The ID of the interest."
        end
        delete ":interest_id" do
          profile_destroy_permissions(params[:id])
          interest = get_record(Interest, params[:interest_id])
          entity_align(interest, @profile)
          interest.destroy!
          status 204
        end
      end


      namespace :location do
        desc "Creates a new location for a profile.", entity: Entities::Profile::LocationData::AsNested
        params do
          requires :geo_string, type: String, allow_blank: false, desc: "The location string for a location."
        end
        post do
          profile_create
          location = @profile.location || Location.new
          location.geo_string = params[:geo_string]
          location.save!
          @profile.save!
        end

        desc "Updates an existing location.", entity: Entities::Profile::LocationData::AsNested
        params do
          requires :location_id, type: Integer, allow_blank: false, desc: "The ID of the location."
          requires :geo_string, type: String, allow_blank: false, desc: "The new location string of the location."
        end
        put ":location_id" do
          profile_udpate_permissions(params[:id])
          location = get_record(Location, params[:location_id])
          entity_align(location, @profile)
          location.geo_string = params[:geo_string]
          location.save!
        end

        desc "Destroy an existing location.", entity: Entities::Profile::LocationData::AsNested
        delete do
          profile_destroy_permissions(params[:id])
          @profile.location.destroy!
          status 204
        end
      end


      namespace :position do
        desc "Creates a new position for a profile.", entity: Entities::Profile::PositionData::AsNested
        params do
          requires :title, type: String, allow_blank: false, desc: "The title of a new position."
          requires :company, type: String, allow_blank: false, desc: "The company of a new position."
        end
        post do
          profile_create
          create_entity(Position, {title: params[:title], company: params[:company]})
          @profile.save!
        end

        desc "Updates an existing interest.", entity: Entities::Profile::InterestData::AsNested
        params do
          requires :interest_id, type: Integer, allow_blank: false, desc: "The ID of the interest."
          requires :title, type: String, allow_blank: false, desc: "The new title of the interest."
        end
        put ":interest_id" do
          profile_udpate_permissions(params[:id])
          interest = get_record(Interest, params[:interest_id])
          entity_align(interest, @profile)
          interest.title = params[:title]
          interest.save!
        end

        desc "Destroy an existing interest.", entity: Entities::Profile::InterestData::AsNested
        params do
          requires :interest_id, type: Integer, allow_blank: false, desc: "The ID of the interest."
        end
        delete ":interest_id" do
          profile_destroy_permissions(params[:id])
          interest = get_record(Interest, params[:interest_id])
          entity_align(interest, @profile)
          interest.destroy!
          status 204
        end
      end
    end


    desc "Create a new profile or subentity for a user.", entity: Entities::ProfileData::AsFull
    params do
      optional :interest_title, type: String, allow_blank: false, desc: "The title of a new interest."
      optional :location_string, type: String, allow_blank: false, desc: "The location string of a new location."
      optional :position_title, type: String, allow_blank: false, desc: "The title of a new position."
      optional :position_company, type: String, allow_blank: false, desc: "The company of a new position."
      optional :school_info_school_name, type: String, allow_blank: false, desc: "The school name of a new school info."
      optional :school_info_grad_year, type: String, allow_blank: false, desc: "The grad year of a new school info."
      optional :school_info_field, type: String, allow_blank: false, desc: "The field of a new school info."
      optional :skill_title, type: String, allow_blank: false, desc: "The title of a new skill."
      all_or_none_of :position_title, :position_company
      all_or_none_of :school_info_school_name, :school_info_grad_year
    end
    post do
      profile_create
      if params[:location_string]
        location = @profile.location || Location.new
        location.profile = @profile
        location.geo_string = params[:location_string]
        @profile.save!
        location.save!
      end

      if params[:interest_title]
        create_entity(Interest, {title: params[:interest_title]})
      end

      if params[:position_title]
        create_entity(Position, {title: params[:position_title], company: params[:position_company]})
      end

      if params[:school_info_school_name]
        create_entity(SchoolInfo, {school_name: params[:school_info_school_name],
                                   grad_year: params[:school_info_grad_year],
                                   field: params[:school_info_field]})
      end

      if params[:skill_title]
        create_entity(Skill, {title: params[:skill_title]})
      end

      present @profile, with: Entities::ProfileData::AsFull
    end


    desc "Deletes a profile or one of its sub-entities", entity: Entities::ProfileData::AsFull
    params do
      requires :id, type: Integer, allow_blank: false, desc: "The profile ID."
      optional :entity_id, type: Integer, allow_blank: false, desc: "The ID of the sub entity to delete."
      optional :entity_name, type: String, allow_blank: false, desc: "The class name of the subentity."
      all_or_none_of :entity_id, :entity_name
    end
    delete ":id" do
      profile_destroy_permissions
      if params[:entity_name]
        error!("400 Entity, #{params[:entity_name]}, does not exist", 400) unless Object.const_defined? params[:entity_name].capitalize
        entity = getRecord(params[:entity_name].capitalize.constantize, params[:entity_id])
        error!("401 Unauthorized: Entity does not belong to profile", 401) unless entity.profile == @profile
      else
        entity = @profile
      end
      entity.destroy!
      status 204
    end


    namespace :interest do
      route_param :id do
        params do
          requires :profile_id, type: Integer, allow_blank: false, desc: "The profile ID."
          requires :title, type: String, allow_blank: false, desc: "The name if the interest"
        end
        post do
        end
      end
    end
  end
end
