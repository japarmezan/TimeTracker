class Label < ActiveRecord::Base
  has_many :tracks
  belongs_to :project

  validates :name, uniqueness: true
  validates :wage, presence: true
end
