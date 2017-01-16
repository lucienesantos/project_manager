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

  def update

    project = Project.find_by_id(params[:id])

    if project.update(project_params)
      render json: {project: project}
    else
      render json: { errors: project.errors.full_messages }, status: :unprocessable_entity
    end

  end

  def conclude
    begin
      project = Project.find(params[:id])
      project.conclude
      render json: {project: project}
    rescue Exception => e
        render json: { errors: e.message }, status: :unprocessable_entity
    end

  end


  private

    def project_params
      params.require(:project).permit(:name, :conclusion_at, :client_id)
    end

end
