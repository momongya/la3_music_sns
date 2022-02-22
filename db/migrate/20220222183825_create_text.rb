class CreateText < ActiveRecord::Migration[6.1]
  def change
    create_table :texts do |t|
      t.integer :user_id
      t.string :artist
      t.string :album_name
      t.string :song_title
      t.string :song_img
      t.string :song_sample
      t.string :comment
      t.timestamps null: false
    end
  end
end
