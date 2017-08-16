class AddSlugToPosts < ActiveRecord::Migration[5.1]
  def up
    add_column :posts, :slug, :string

    Post.find_each do |post|
      post.send :set_slug
      post.update_columns slug: post.slug
    end

    change_column_null :posts, :slug, false
    add_index :posts, :slug, unique: true
  end

  def down
    remove_column :posts, :slug
  end
end
