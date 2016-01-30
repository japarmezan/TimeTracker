class Project < ActiveRecord::Base
      resourcify
      include Authority::Abilities
      belongs_to :author, class_name: 'User'
	belongs_to :category
	has_many :tracks
      has_many :contributors
      has_many :coworkers, through: :contributors, source: :user
      self.authorizer_name = 'ProjectAuthorizer'
end
