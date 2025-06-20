class AddTopicToConversations < ActiveRecord::Migration[7.1]
  def change
    add_column :conversations, :topic, :string
  end
end
