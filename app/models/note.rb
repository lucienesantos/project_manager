class Note < ApplicationRecord

  belongs_to :project

  validates :content, :project, presence: true

  before_create :complete_status_project


  def complete_status_project
    if self.conclude_project
      self.project.conclude
    end
  end

end
