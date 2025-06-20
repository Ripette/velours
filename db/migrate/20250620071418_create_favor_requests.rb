class CreateFavorRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :favor_requests do |t|
      t.references :sender, null: false, foreign_key: { to_table: :users }
      t.references :receiver, null: false, foreign_key: { to_table: :users }
      t.text :message
      t.string :status

      t.timestamps
    end
  end
end
