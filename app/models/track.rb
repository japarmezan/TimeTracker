class Track < ActiveRecord::Base
  belongs_to :project
  belongs_to :label
  belongs_to :user
end
