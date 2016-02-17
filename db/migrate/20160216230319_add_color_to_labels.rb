class AddColorToLabels < ActiveRecord::Migration
  def change
    add_column :labels, :color, :integer
  end
end
