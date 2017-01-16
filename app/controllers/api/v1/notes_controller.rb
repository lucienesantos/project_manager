class Api::V1::NotesController < ApplicationController

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

	private
		def notes_params
			params.require(:note).permit(:content, :conclude_project, :project_id)
		end

end
