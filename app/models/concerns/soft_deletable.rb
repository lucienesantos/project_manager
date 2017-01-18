module SoftDeletable

	def soft_delete
		self.update({archived: true, archived_at: Time.zone.now})
	end

end
