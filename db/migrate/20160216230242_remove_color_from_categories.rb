class RemoveColorFromCategories < ActiveRecord::Migration
  def change
    remove_column :categories, :color, :integer
  end
end
