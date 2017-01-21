class Api::V1::NotesController < ApplicationController

	def index
		paginate json: Note.by_project_id(params[:id]).sort_by_creation, per_page: params[:per_page]
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
		note = Note.by_project_id(params[:id]).find(params[:note_id])
		note.soft_delete
    render json: note
	end

	private
		def notes_params
			params.require(:note).permit(:content, :conclude_project, :project_id)
		end

end
