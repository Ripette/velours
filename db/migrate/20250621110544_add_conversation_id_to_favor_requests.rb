class AddConversationIdToFavorRequests < ActiveRecord::Migration[7.1]
  def change
    add_column :favor_requests, :conversation_id, :integer
  end
end
