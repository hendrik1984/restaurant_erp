class CreateModifierOptions < ActiveRecord::Migration[8.1]
  def change
    create_table :modifier_options do |t|
      t.references :modifier_group, null: false, foreign_key: true
      t.string :name, null: false
      t.decimal :price_delta, precision: 10, scale: 2, null: false, default: 0
      t.boolean :available, null: false, default: true
      t.integer :position, null: false, default: 0

      t.timestamps
    end
    add_index :modifier_options, [ :modifier_group_id, :position ]
  end
end
