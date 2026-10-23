class AddCustomFieldToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :name, :string, null: false
    add_column :users, :phone, :string
    add_column :users, :pin_digest, :string
    add_reference :users, :role, foreign_key: true, null: false
    add_column :users, :status, :integer, null: false, default: 0
  end
end
