class User < ActiveRecord::Base
  include Authority::UserAbilities
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :categories
  has_many :projects, foreign_key: :author_id
  has_many :contributors
  has_many :tasks, through: :contributors, source: :project
  has_many :tracks

  validates :name, :additional, presence: true
end
