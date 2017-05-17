class Reindex2 < ActiveRecord::Migration[5.1]
  def change
    Post.reindex
  end
end
