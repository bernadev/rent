class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :url
      t.float :time
      t.float :price
      t.string :status
      t.string :requirements
      t.string :description
      t.boolean :discarded

      t.timestamps null: false
    end
    add_index :rooms, :url, unique: true
  end
end
