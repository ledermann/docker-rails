class Reindex < ActiveRecord::Migration[5.1]
  def change
    Page.reindex
  end
end
