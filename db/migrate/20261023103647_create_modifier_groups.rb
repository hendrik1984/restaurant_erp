class CreateModifierGroups < ActiveRecord::Migration[8.1]
  def change
    create_table :modifier_groups do |t|
      t.references :menu_item, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :min_select, null: false, default: 0
      t.integer :max_select, null: false, default: 1
      t.boolean :required, null: false, default: false
      t.integer :position, null: false, default: 0

      t.timestamps
    end
    add_index :modifier_groups, [ :menu_item_id, :position ]
  end
end
