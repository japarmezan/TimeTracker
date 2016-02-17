class Label < ActiveRecord::Base
  has_many :tracks
  belongs_to :project
  enum color: [:red, :green, :blue, :orange]

  validates :name, :uniqueness => { :scope => :project }
  validates :wage, presence: true
end
