class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true

  has_many :submitted_urls,
    class_name: 'ShortenedUrl',
    foreign_key: :user_id,
    primary_key: :id

  has_many :visits,
    class_name: 'Visit',
    foreign_key: :visitor_id,
    primary_key: :id

  has_many :visited_urls,
    -> { distinct },
    through: :visits,
    source: :visited_url

  attr_accessor :link_count

  def increase_link_count
    if @link_count.nil?
      @link_count = 1
    else
      @link_count += 1
    end
  end

  def make_premium
    User.update(self.id, premium: true)
  end
end
