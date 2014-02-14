class AddDeletedToNewsPosts < ActiveRecord::Migration
  def change
    add_column :news_posts, :deleted, :boolean, default: 0
  end
end
