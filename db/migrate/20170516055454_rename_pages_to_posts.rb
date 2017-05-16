class RenamePagesToPosts < ActiveRecord::Migration[5.1]
  def change
    rename_table 'pages', 'posts'
    Post.reindex
  end
end
