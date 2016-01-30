class ChangeColumnName < ActiveRecord::Migration
  def change
    rename_column :projects, :user_id, :author_id
  end
end
