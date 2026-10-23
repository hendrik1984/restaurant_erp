class CreateBanners < ActiveRecord::Migration[8.1]
  def change
    create_table :banners do |t|
      t.string :title, null: false
      t.string :image_url
      t.string :link_url
      t.datetime :starts_at
      t.datetime :ends_at
      t.boolean :active, null: false, default: true
      t.integer :position, null: false, default: 0

      t.timestamps
    end
  end
end
