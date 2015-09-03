class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :identifying_value
      t.string :name, null: false
      t.text :description

      t.timestamps null: false
    end
    add_index :groups, :identifying_value, unique: true
    add_index :groups, :name, unique: true
  end
end
