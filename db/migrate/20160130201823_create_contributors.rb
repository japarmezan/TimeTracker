class CreateContributors < ActiveRecord::Migration
  def change
    create_table :contributors, :id => false do |t|
      t.references :project
      t.references :user
    end
    add_index :contributors, [:project_id, :user_id]
    add_index :contributors, :user_id
  end
end
