module ActiveRecord
  module FinderMethods
    alias :orig_find_one :find_one
    def find_one(id)
      if id.is_a?(String)
        orig_find_one decrypt_id(id)
      else
        orig_find_one(id)
      end
    end
  end
end
