class Invoice < ActiveRecord::Base
  belongs_to :project

  validates :from, :to, presence: true
end
