class Track < ActiveRecord::Base
  include Authority::Abilities
  belongs_to :project
  belongs_to :label
  belongs_to :user

  self.authorizer_name = 'TrackAuthorizer'
  validates :status, :user, presence: true
  validates :status, inclusion: { in: %w(started paused resumed stopped uploaded),
    message: "%{value} is not a valid status." }
  validates_with TrackValidator
end
