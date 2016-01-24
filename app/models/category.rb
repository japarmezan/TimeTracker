class Category < ActiveRecord::Base
	has_many :projects
	enum color: [:black, :red, :green, :blue, :orange, :purple]
end
