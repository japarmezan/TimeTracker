require 'hashids'

module HashidsSupport
  module ClassMethods
    def hashids
      Hashids.new(table_name, 5)
    end

    def encode_id(id)
      hashids.encode(id)
    end

    def decode_id(id)
      hashids.decode(id).first
    end
  end

  def self.included(base)
    base.extend ClassMethods
  end

  def encoded_id
    self.class.encode_id(id)
  end

  def to_param
    encoded_id
  end
end

ActiveRecord::Base.send :include, HashidsSupport
