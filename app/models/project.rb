class Project < ApplicationRecord
    include SoftDeletable

  STATES = ["started", "approving", "building", "concluded" ]

  belongs_to :client
  has_many :notes

  validates :name, :state, :conclusion_at, :client, presence: true
  validates :state, inclusion: { in: STATES }

  scope :sort_by_creation, -> { order(created_at: :DESC)}

  def conclude
    self.update({state: "concluded", conclusion_at: Time.zone.now })
  end

end
