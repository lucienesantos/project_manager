class Api::V1::NotesController < ApplicationController

	def index
		notes = Note.by_project_id(params[:id]).sort_by_creation
		render json: notes
	end

	def create
		begin
			note = Note.new(notes_params)
			note.project = Project.find(params[:id])
			note.save
		  render json: { note: note }, status: :created
		rescue Exception => e
			render json: { errors: e.message }, status: :unprocessable_entity
		end
	end

	def archive
		note = Note.find(params[:id])
		note.soft_delete
    render json: note
	end

	private
		def notes_params
			params.require(:note).permit(:content, :conclude_project, :project_id)
		end

end
