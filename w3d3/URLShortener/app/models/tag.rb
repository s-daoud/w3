class Tag < ActiveRecord::Base
  validates :topic, presence: true

  has_many :tagged_urls,
    -> { distinct },
    through: :taggings,
    source: :tagged_url

end
