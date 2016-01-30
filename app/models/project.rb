class Project < ActiveRecord::Base
      resourcify
      include Authority::Abilities
      belongs_to :author, class_name: 'User'
	belongs_to :category
	has_many :tracks
      self.authorizer_name = 'ProjectAuthorizer'
end
