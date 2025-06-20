class AddCategoryToFavorRequests < ActiveRecord::Migration[7.1]
  def change
    add_column :favor_requests, :category, :string
  end
end
