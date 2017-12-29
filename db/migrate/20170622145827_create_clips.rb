class CreateClips < ActiveRecord::Migration[5.1]
  def change
    create_table :clips do |t|
      t.integer :post_id, null: false
      t.text :image_data, null: false

      t.timestamps
    end

    add_column :posts, :clips_count, :integer, default: 0
    remove_column :posts, :image_data, :text
  end
end
