require_relative './validators/valid_user'
require_relative './validators/valid_pagination'

module V1
  class Benchmarks < Grape::API
    helpers do
      def benchmark_put_permissions(id)
        authenticated_user
        @benchmark ||= get_record(Bmark, id)
        error!("401 Unauthorized", 401) unless @benchmark.has_put_permissions current_user
      end

      def benchmark_destroy_permissions(id)
          authenticated_user
          @benchmark ||= get_record(Bmark, id)
          error!("401 Unauthorized", 401) unless @benchmark.has_destroy_permissions current_user
      end
    end


    desc "Retrieve all benchmarks for a project", entity: Entities::BenchmarkData::AsShallow
    params do
      requires :project, type: Integer, allow_blank: false, desc: "The Project ID for the benchmarks to retreive."
      optional :title, type: String, desc: "The title of the project benchmark to retrieve."
      optional :per_page, type: Integer, default: 25, valid_per_page: [1, 100], allow_blank: false, desc: "The number of benchmarks per page."
      optional :page, type: Integer, default: 1, allow_blank: false, desc: "The page number of the benchmarks."
    end
    get do
      present Bmark.where(permitted_params params)
        .page(params[:page])
        .per(params[:per_page]), with: Entities::BenchmarkData::AsShallow
    end


    desc "Get a single benchmark based on its ID.", entity: Entities::BenchmarkData::AsDeep
    params do
      requires :id, type: Integer, allow_blank: false, desc: "The benchmark ID."
    end
    get ":id" do
      benchmark = get_record(Bmark, params[:id])
      present benchmark, with: Entities::BenchmarkData::AsDeep
    end


    desc "Create a new benchmark for a project.", entity: Entities::BenchmarkData::AsShallow
    params do
      requires :title, type: String, allow_blank: false, desc: "The title of the benchmark for the project."
      requires :project, type: Integer, allow_blank: false, desc: "The project ID to which the benchmark will belong."
      optional :due_date, type: DateTime, allow_blank: false, desc: "The benchmark's due date."
    end
    post do
      authenticated_user
      proj = get_record(Project, params[:project])
      if proj.has_create_benchmark_permissions current_user
        benchmark = Bmark.create!({
          title: params[:title],
          project: proj,
          due_date: params[:due_date],
          user: current_user
        })
        present benchmark, with: Entities::BenchmarkData::AsShallow
      else
        error!("401 Unauthorized", 401)
      end
    end


    desc "Update a specific benchmark for a project.", entity: Entities::RoleData::AsShallow
    params do
      requires :id, type: Integer, allow_blank: false, desc: "The benchmark ID."
      optional :title, type: String, allow_blank: false, desc: "The benchmark title."
      optional :complete, type: Boolean, allow_blank: false, desc: "The benchmark's completeness."
      # this needs to be in iso8601 format:
      # https://en.wikipedia.org/wiki/ISO_8601
      optional :due_date, type: DateTime, allow_blank: false, desc: "The benchmark's due date."
      at_least_one_of :title, :complete, :due_date
    end
    put ":id" do
      benchmark_put_permissions(params[:id])

      if !!params[:title]
        @benchmark.title = params[:title]
      end

      if !!params[:complete]
        @benchmark.complete = params[:complete]
      end

      if !!params[:due_date]
        @benchmark.due_date = params[:due_date]
      end

      @benchmark.save
      present @benchmark, with: Entities::BenchmarkData::AsShallow
    end


    desc "Delete a benchmark from a project."
    params do
      requires :id, type: Integer, allow_blank: false, desc: "The benchmark's ID."
    end
    delete ":id" do
      benchmark_destroy_permissions(params[:id])
      @benchmark.destroy
      status 204
    end

  end
end
