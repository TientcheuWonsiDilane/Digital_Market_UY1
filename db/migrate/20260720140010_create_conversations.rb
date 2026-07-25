class CreateConversations < ActiveRecord::Migration[8.1]
  def change
    create_table :conversations do |t|
      t.references :sender, null: false, foreign_key: { to_table: :users }
      t.references :recipient, null: false, foreign_key: { to_table: :users }
      t.references :store, null: true, foreign_key: true
      t.timestamps
    end
    add_index :conversations, [:sender_id, :recipient_id], unique: true
  end
end
