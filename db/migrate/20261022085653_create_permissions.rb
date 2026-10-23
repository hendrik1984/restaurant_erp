class CreatePermissions < ActiveRecord::Migration[8.1]
  def change
    create_table :permissions do |t|
      t.string :module, null: false
      t.string :action, null: false

      t.timestamps
    end

    add_index :permissions, [:module, :action], unique: true
  end
end
