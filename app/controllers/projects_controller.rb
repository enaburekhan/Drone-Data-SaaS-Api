class ProjectsController < ApplicationController
    # require user to be logged in with JWT
    before_action :authenticate_user!  

    # get /projects
    def index
      @projects = current_user.projects.order(created_at: :desc)
      render json: @projects, status: :ok
    end

    # get /projects/:id
    def show
      project = current_user.projects.find(params[:id])
      render json: projects, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Project not found" }, status: :not_found
    end

    # post /projects
    def create
      project = current_user.projects.build(project_params)
      if project.save
        render json: project, status: :created
      else
        render json: { errors: project.errors.full_messages }, status: :unprocessable_content
      end
    end

    # put/patch /projects/:id
    def update
      project = current_user.projects.find(params[:id])
      if project.update(project_params)
        render json: project, status: :ok
      else
        render json: { errors: project.errors.full_messages }, status: :unprocessable_content
      end
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Project not found" }, status: :not_found
    end

    # delete /projects/:id
    def destroy
      project = current_user.projects.find(params[:id])
      project.destroy
      render json: { message: "Project deleted" }, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Project not found" }, status: :not_found
    end


    private

    def project_params
      params.require(:project).permit(:name, :location, :description)
    end
end
