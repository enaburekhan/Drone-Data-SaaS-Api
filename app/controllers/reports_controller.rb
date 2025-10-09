class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:index, :create]

  # /projects/:project_id/reports
  def index
    reports = @project.reports.order(created_at: :desc)
    render json: reports
  end

  # Post /projects/:project_id/reports
  def create
    report = @project.reports.build(report_params)

    if report.save
      render json: { message: "report created successfully", report: report }, status: :created 
    else
        render json: { errors: report.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # auto-generate report from processed resilts
  # post /projects/:project_id/reports/generate
  def generate
    report = Report.generate_for_project(@project)
    render json: report, status: :created
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def report_params
    params.require(:report).permit(:title, :summary, :insights: {})
  end
end
