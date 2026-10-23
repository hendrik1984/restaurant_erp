class CreateMenuItems < ActiveRecord::Migration[8.1]
  def change
    create_table :menu_items do |t|
      t.references :category, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.decimal :price, precision: 10, scale: 2, null: false
      t.boolean :available, null: false, default: true
      t.decimal :tax_rate, precision: 5, scale: 2, default: 0
      t.integer :position, null: false, default: 0

      t.timestamps
    end
    add_index :menu_items, [ :category_id, :position ]
    add_index :menu_items, :available
  end
end
