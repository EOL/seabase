class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, unique: true
      t.string :name
      t.string :password_hash
      t.string :token
      t.timestamp
    end
  end
end
