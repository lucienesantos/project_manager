class Project < ApplicationRecord

  STATES = ["started", "approving", "building", "completed", "concluded" ]

  belongs_to :client

  validates :name, :state, :conclusion_at, :client, presence: true

  validates :state, inclusion: { in: STATES }

end
