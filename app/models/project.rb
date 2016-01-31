class Project < ActiveRecord::Base
      resourcify
      include Authority::Abilities
      belongs_to :author, class_name: 'User'
	belongs_to :category
	has_many :tracks
      has_many :contributors
      has_many :coworkers, through: :contributors, source: :user
      self.authorizer_name = 'ProjectAuthorizer'

      validates :name, presence: true
      validates :description, presence: true
      validates :category_id, presence: true
end
