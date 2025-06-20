class AddPartnerToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :partner_email, :string
  end
end
