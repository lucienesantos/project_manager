class Note < ApplicationRecord
  include SoftDeletable

  belongs_to :project

  validates :content, :project, presence: true

  before_create :complete_status_project

  scope :by_project_id, ->(project_id) {where("project_id = ?", project_id)}


  def complete_status_project
    if self.conclude_project
      self.project.conclude
    end
  end

end
