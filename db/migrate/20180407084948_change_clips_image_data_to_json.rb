class ChangeClipsImageDataToJson < ActiveRecord::Migration[5.2]
  def up
    change_column :clips, :image_data, :jsonb, using: 'image_data::jsonb'
  end

  def down
    change_column :clips, :image_data, :text
  end
end
