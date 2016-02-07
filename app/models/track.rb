class Track < ActiveRecord::Base
  belongs_to :project
  belongs_to :label
  belongs_to :user
<<<<<<< HEAD

  validates :status, :user, presence: true
  validates :status, inclusion: { in: %w(started paused resumed stopped uploaded),
    message: "%{value} is not a valid status." }
  validates_with TrackValidator
=======
>>>>>>> 17d1878885c304d052a108cffb4fb771ed94c3e0
end
