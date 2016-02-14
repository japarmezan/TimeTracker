# Invoice authorizer
class InvoiceAuthorizer < ApplicationAuthorizer
  # Any class method from Authority::Authorizer that isn't overridden
  # will call its authorizer's default method.
  #
  # @param [Symbol] adjective; example: `:creatable`
  # @param [Object] user - whatever represents the current user in your app
  # @return [Boolean]
  def self.default(_adjective, _user)
    # 'Whitelist' strategy for security: anything not explicitly allowed is
    # considered forbidden.
    false
  end

  def updatable_by?(user)
    resource.project.author == user
  end

  def self.updatable_by?(user)
    !user.nil?
  end

  def readable_by?(user)
    resource.project.author == user
  end

  def self.readable_by?(user)
    !user.nil?
  end

  def creatable_by?(user)
    !user.nil?
  end

  def self.creatable_by?(user)
    !user.nil?
  end
end
