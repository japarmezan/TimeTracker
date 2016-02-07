class Project < ActiveRecord::Base
<<<<<<< HEAD
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
=======
      resourcify
      include Authority::Abilities
      belongs_to :author, class_name: 'User'
	belongs_to :category
	has_many :tracks
      has_many :contributors
      has_many :coworkers, through: :contributors, source: :user
      has_many :labels
      self.authorizer_name = 'ProjectAuthorizer'

      validates :name, presence: true
      validates :description, presence: true
      validates :category_id, presence: true

      def set_contributors(emails)
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
            if coworkers.where(email: e).length == 0 and e != author.email
              coworkers << User.where(email: e)
            end
          end
      end

      def remove_redundant_contributors(emails)
          coworkers.each do |c|
            unless emails.include?(c.email)
              coworkers.delete(c)
            end
          end
      end
>>>>>>> 17d1878885c304d052a108cffb4fb771ed94c3e0
end
