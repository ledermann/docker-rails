class AddCopyrightToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :copyright, :text
  end
end
