class Api::V1::ProjectsController < ApplicationController

  def index
    paginate json: Project.all.sort_by_creation, per_page: params[:per_page]
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

  def archive
    projects = Project.where(id: params[:ids])
    projects.map(&:soft_delete)
    render status: :no_content
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
