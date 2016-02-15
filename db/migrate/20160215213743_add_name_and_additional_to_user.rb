class AddNameAndAdditionalToUser < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :additional, :string
  end
end
