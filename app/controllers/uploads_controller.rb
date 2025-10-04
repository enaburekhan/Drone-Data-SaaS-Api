class UploadsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project

  # get /projects/:project_id/uploads
  def index
    uploads = @project.uploads.order(created_at: :desc)
    render json: uploads
  end

  # get /projects/:project_id/uploads/:id
  def show
    upload = @project.uploads.find(params[:id])
    render json: upload
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Upload not found" }, status: :not_found
  end

  # post /projects/:project_id/uploads
  def create
    upload = @project.uploads.build(upload_params)
    upload.status = "pending"

    if upload.save
      # attach file (from ActiveStorage)
      upload.file.attach(params[:file]) if params[:file].present?

      render json: upload, status: :created
    else
      render json: { errors: upload.errors.full_messages }, status: :unprocessable_content
    end
  end

  private

  def set_project
    @project = current_user.projects.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Project not found" }, status: :not_found
  end

  def upload_params
    params.permit(:status, :metadata) # file handled seperately
  end
end
