class Track < ActiveRecord::Base
  belongs_to :project
  belongs_to :label
  belongs_to :user

  validates :status, :user, presence: true
  validates :status, inclusion: { in: %w(started paused resumed stopped uploaded),
    message: "%{value} is not a valid status." }
  validates_with TrackValidator
end
