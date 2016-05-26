class ShortenedUrl < ActiveRecord::Base
  validates :long_url, :user_id, presence: true
  validates :short_url, uniqueness: true

  belongs_to :submitter,
    class_name: 'User',
    foreign_key: :user_id,
    primary_key: :id

  has_many :visits,
    class_name: 'Visit',
    foreign_key: :visited_url_id,
    primary_key: :id

  has_many :visitors,
    -> { distinct },
    through: :visits,
    source: :visitor

  has_one :tag,
    -> { distinct },
    through: :taggings,
    source: :tag

  def self.random_code
    code = nil
    while code.nil? || ShortenedUrl.exists?(short_url: code)
      code = SecureRandom.urlsafe_base64
    end
    code
  end

  def self.create_for_user_and_long_url!(user, long_url)
    ShortenedUrl.create!(long_url: long_url, short_url: ShortenedUrl.random_code, user_id: user.id)
  end

  def make_custom(custom)
    ShortenedUrl.update(self.id, short_url: custom)
  end

  def num_clicks
    self.visits.count
  end

  def num_uniques
    self.visitors.count
  end

  def num_recent_uniques
    self.visitors.where("visits.created_at < ?", 10.minutes.ago).count
  end
end
