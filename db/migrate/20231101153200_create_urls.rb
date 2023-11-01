class CreateUrls < ActiveRecord::Migration[7.1]
  def change
    create_table :urls do |t|
      t.text :origin
      t.text :shortened
      t.integer :clicked, default: 0

      t.timestamps
    end
    add_index :urls, :shortened, unique: true
  end
end
