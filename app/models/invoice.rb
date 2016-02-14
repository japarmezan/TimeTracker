class Invoice < ActiveRecord::Base
  belongs_to :project
  include Authority::Abilities

  validates :from, :to, presence: true
  self.authorizer_name = 'InvoiceAuthorizer'
end
