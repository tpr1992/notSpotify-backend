class CreatePlaylists < ActiveRecord::Migration[5.2]
  def change
    create_table :playlists do |t|
      t.string :title
      t.string :images
      t.integer :track_count
      t.string :created_by
      t.string :spotify_url
      t.string :tracks_added_at
      t.string :tracks
      t.timestamps
      t.timestamps
    end
  end
end
