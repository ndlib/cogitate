class CreateCogitateModelsIdentifierTickets < ActiveRecord::Migration
  def change
    create_table :cogitate_models_identifier_tickets do |t|
      t.string :encoded_id, null: false
      t.string :ticket, null: false
      t.datetime :expires_at, null: false

      t.timestamps null: false
    end
    add_index :cogitate_models_identifier_tickets, [:ticket, :expires_at], name: :idx_cogitate_models_identifier_ticket_expiry
    add_index :cogitate_models_identifier_tickets, :encoded_id
    add_index :cogitate_models_identifier_tickets, :ticket, unique: true
  end
end
