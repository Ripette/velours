class AddDefaultStatusToFavorRequests < ActiveRecord::Migration[7.1]
  def change
    change_column_default :favor_requests, :status, 'pending'
  end
end
