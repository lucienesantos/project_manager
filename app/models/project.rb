class Project < ApplicationRecord

  STATES = ["started", "approving", "building", "completed", "concluded" ]

  belongs_to :client
  has_many :notes

  validates :name, :state, :conclusion_at, :client, presence: true
  validates :state, inclusion: { in: STATES }

  scope :sort_by_creation, -> { order(created_at: :DESC)}

end
