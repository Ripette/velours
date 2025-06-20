class AddSenderAndRecipientToConversations < ActiveRecord::Migration[7.1]
  def change
    add_reference :conversations, :sender, null: false, foreign_key: { to_table: :users }
    add_reference :conversations, :recipient, null: false, foreign_key: { to_table: :users }
  end
end
