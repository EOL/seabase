# Describes Seabase's user
class User < ActiveRecord::Base
  has_many :roles_users
  has_many :news_posts
  has_many :roles, through: :roles_users

  def roles_names
    roles.map(&:name)
  end

  def admin?
    roles_names.include?("admin")
  end
end
