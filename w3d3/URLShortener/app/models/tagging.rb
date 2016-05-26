class Tagging < ActiveRecord::Base
  validates :tag_id, :tagged_url_id, presence: true

  belongs_to :tag,
    class_name: 'Tag',
    foreign_key: :tag_id,
    primary_key: :id

  belongs_to :tagged_url,
    class_name: 'ShortenedUrl',
    foreign_key: :tagged_url_id,
    primary_key: :id

  def self.add_tag!(tag, shortened_url)
    Tagging.create(tag_id: tag.id, tagged_url_id: shortened_url.id)
  end
end
