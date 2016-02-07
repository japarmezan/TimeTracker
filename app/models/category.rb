class Category < ActiveRecord::Base
	has_many :projects
    belongs_to :user
	enum color: [:black, :red, :green, :blue, :orange]

  	validates :name, uniqueness: true
end
