class NewsPost < ActiveRecord::Base
  belongs_to :user

  def self.visible_news
    NewsPost.where(deleted: 0).order(created_at: :desc)
  end
end
