class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :news_post
      t.references :user
      t.integer :parent
      t.text :body
      t.timestamps
    end
  end
end
