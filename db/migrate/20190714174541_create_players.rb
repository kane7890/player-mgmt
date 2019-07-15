class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :firstname
      t.string :lastname
      t.string :position
      t.integer :user_id
      t.timestamps null: false
    end
  end
end
