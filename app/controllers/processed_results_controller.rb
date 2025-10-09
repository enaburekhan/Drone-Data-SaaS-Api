class ProcessedResultsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_upload
  before_action :set_project

  # get /projects/:project_id/uploads/:upload_id/processes_results
  def index
    @processed_results = @upload.processed_results.order(created_at: :desc)
    render json: @processed_results
  end

  # get /projects/:project_id/uploads/:upload_id/processed_results/:id
  def show
    render json: @processed_result
  end

  # post /projects/:project_id/uploads/:upload_id/processed_results
  def create
    @processed_result = @upload.processed_results.build(processed_result_params)

    if @processed_result.save
      # Example: enqueue background job if you process data asynchronously
      # ProcessedResultJob.perform_async(@processed_result.id)

      render json: { message: "Processed result created successfully", processed_result: @processed_result },
             status: :created
    else
      render json: { errors: @processed_result.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Project not found" }, status: :not_found
  end

  def set_upload
    @upload = Upload.find(params[:upload_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Upload not found" }, status: :not_found
  end

  def processed_result_params
    # don't include :upload_id since it comes from nested route
    params.expect(processed_result: [:result_type, :data_url, { metadata: {} }])
  end
end
