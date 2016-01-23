class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.datetime :start
      t.datetime :end
      t.text :comment

      t.timestamps null: false
    end
  end
end
