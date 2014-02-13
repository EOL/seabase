class CreateRolesUsers < ActiveRecord::Migration
  def change
    create_table :roles_users do |t|
      t.references :user
      t.references :role
    end

    add_index :roles_users, [:user_id, :role_id], 
      name: :idx_roles_users_1, unique: true
  end
end
