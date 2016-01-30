class Project < ActiveRecord::Base
	belongs_to :category
	has_many :tracks
end
