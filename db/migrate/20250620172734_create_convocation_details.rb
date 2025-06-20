class CreateConvocationDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :convocation_details do |t|
      t.belongs_to :favor_request, null: false, foreign_key: true
      t.string :location
      t.string :timing
      t.string :attire
      t.string :mood

      t.timestamps
    end
  end
end
