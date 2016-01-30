class AddProjectToTracks < ActiveRecord::Migration
  def change
    add_reference :tracks, :project, index: true, foreign_key: true
  end
end
