class AddLabelToTracks < ActiveRecord::Migration
  def change
    add_reference :tracks, :label, index: true, foreign_key: true
  end
end
