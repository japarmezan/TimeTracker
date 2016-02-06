class Label < ActiveRecord::Base
  has_many :tracks
  belongs_to :project
end
