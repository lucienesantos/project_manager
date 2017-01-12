class Api::V1::ProjectsController < ApplicationController

  def index
    projects = Project.all.sort_by_creation
    render json: projects
  end
  
end
