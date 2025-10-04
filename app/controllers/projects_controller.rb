class ProjectsController < ApplicationController
  # require user to be logged in with JWT
  before_action :authenticate_user!
  before_action :set_project, only: %i[show update destroy]

  # get /projects
  def index
    projects = current_user.projects.order(created_at: :desc)

    render json: { type: "FeatureCollection", features: projects.map(&:to_geojson_feature) }, status: :ok
  end

  # get /projects/:id
  def show
    render json: @project.to_geojson_feature, status: :ok
  end

  # post /projects
  def create
    project = current_user.projects.build(project_params)

    if project.save
      render json: project.to_geojson_feature, status: :created
    else
      render json: { errors: project.errors.full_messages }, status: :unprocessable_content
    end
  end

  # put/patch /projects/:id
  def update
    if @project.update(project_params)
      render json: @project.to_geojson_feature, status: :ok
    else
      render json: { errors: @project.errors.full_messages }, status: :unprocessable_content
    end
  end

  # delete /projects/:id
  def destroy
    @project.destroy!
    render json: { message: "Project deleted" }, status: :ok
  end

  private

  def set_project
    @project = current_user.projects.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Project not found" }, status: :not_found
  end

  def project_params
    params.expect(project: %i[name description latitude longitude])
  end
end
