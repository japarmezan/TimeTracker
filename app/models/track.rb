class Track < ActiveRecord::Base
  belongs_to :project
  belongs_to :label
end
