class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.text :description
      t.integer :user_id
      t.string :phone_number
      t.timestamps null: false
    end
  end
end
