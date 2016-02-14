class Project < ActiveRecord::Base
  resourcify
  include Authority::Abilities
  belongs_to :author, class_name: 'User'
  belongs_to :category
  has_many :tracks
  has_many :contributors
  has_many :coworkers, through: :contributors, source: :user
  has_many :labels
  has_many :invoices
  self.authorizer_name = 'ProjectAuthorizer'

  validates :name, presence: true
  validates :description, presence: true
  validates :client, presence: true
  validates :category_id, presence: true

  def configure_contributors(emails)
    add_new_contributors(emails)
    remove_redundant_contributors(emails)
  end

  def tracks_for_user_by_email(email)
    u = User.where(email: email).first
    tracks_for_user(u)
  end

  def tracks_for_user(user)
    tracks.where(user_id: user.id)
  end

  private

  def add_new_contributors(emails)
    emails.each do |e|
      coworkers << User.where(email: e) if coworkers.where(email: e).length == 0 && e != author.email
    end
  end

  def remove_redundant_contributors(emails)
    coworkers.each do |c|
      coworkers.delete(c) unless emails.include?(c.email)
    end
  end
end
