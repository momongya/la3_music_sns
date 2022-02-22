class CreateFavorite < ActiveRecord::Migration[6.1]
  def change
    create_table :favorites do |t|
      t.integer :text_id
      t.integer :user_id
      t.timestamps null: false
    end
  end
end
