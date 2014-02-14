class CreateNewsPosts < ActiveRecord::Migration
  def change
    create_table :news_posts do |t|
      t.references :user
      t.string :subject
      t.text :body
      t.timestamps
    end
  end
end
