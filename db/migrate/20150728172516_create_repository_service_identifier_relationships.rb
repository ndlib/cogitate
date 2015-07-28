class CreateRepositoryServiceIdentifierRelationships < ActiveRecord::Migration
  def change
    create_table :repository_service_identifier_relationships do |t|
      t.string :left_strategy, null: false
      t.string :left_identifying_value, null: false
      t.string :right_strategy, null: false
      t.string :right_identifying_value, null: false

      t.timestamps null: false
    end

    add_index(
      :repository_service_identifier_relationships, [:left_strategy, :left_identifying_value], name: :idx_rs_identifier_relationships_left
    )
    add_index(
      :repository_service_identifier_relationships, [:right_strategy, :right_identifying_value],
      name: :idx_rs_identifier_relationships_right
    )
    add_index(
      :repository_service_identifier_relationships,
      [:left_strategy, :left_identifying_value, :right_strategy, :right_identifying_value],
      name: :idx_rs_identifier_relationships_both, unique: true
    )
  end
end
