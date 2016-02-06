class AddWageToLabels < ActiveRecord::Migration
  def change
    add_column :labels, :wage, :decimal, :precision => 8, :scale => 2
  end
end
