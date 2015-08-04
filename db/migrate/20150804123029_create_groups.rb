class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups, id: false do |t|
      t.string :id, primary_key: true
      t.string :name, null: false
      t.text :description

      t.timestamps null: false
    end
    add_index :groups, :id, unique: true
    add_index :groups, :name, unique: true
  end
end
