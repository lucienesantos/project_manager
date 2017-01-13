class Api::V1::ProjectsController < ApplicationController

  def index
    projects = Project.all.sort_by_creation
    render json: projects
  end

  def create

    project = Project.new(project_params)
    project.client = Client.find_by_id(project_params[:client_id])

    if project.save
      render json: { project: project }, status: :created
    else
      render json: { errors: project.errors.full_messages }, status: :unprocessable_entity
    end

  end

  private

    def project_params
      params.require(:project).permit(:name, :conclusion_at, :client_id)
    end
  
end
