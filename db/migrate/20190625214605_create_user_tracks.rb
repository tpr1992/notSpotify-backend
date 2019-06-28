class CreateUserTracks < ActiveRecord::Migration[5.2]
  def change
    create_table :user_tracks do |t|

      t.timestamps
    end
  end
end
