class AddProjectToLabels < ActiveRecord::Migration
  def change
    add_reference :labels, :project, index: true, foreign_key: true
  end
end
