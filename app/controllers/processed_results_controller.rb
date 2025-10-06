class ProcessedResultsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_upload, only: [:index, :create]
  before_action :set_processed_result, only: [:show]

  
  # get /uploads/:upload_id/processes_results
  def index
    @processed_results = @upload.processed_results
    render json: @processed_results
  end

  # get /processed_results/:id
  def show
    render json: @processes_result
  end

  # post /uploads/:upload_id/processes_results
  def create
    @processed_result = @upload.processed_results.new(processed_result_params)

    if @processed_result.save
      render json: @processed_result, status: :created
    else
      render json: { errors: @processed_result.errors.full_messages }, status: :unprocessable_content
    end
  end

  private

  def set_upload
    @upload = Upload.find(params[:upload_id])
  end

  def set_processed_result
    @processed_result = ProcessedResult.find(params[:id])
  end

  def processed_result_params
    params.require(:processed_result).permit(:result_type, :data_url, metadata: {})
  end
end
