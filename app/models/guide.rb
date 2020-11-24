class Guide < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :user
  has_many :slides

  has_one_attached :thumbnail

  def thumbnail_url
    if self.thumbnail.attached?
      Rails.application.routes.url_helpers.rails_blob_path(self.thumbnail, only_path: true)
    else
      nil
    end
  end

  def test_url
    rails_blob_path(self.thumbnail) if self.thumbnail.attached?
  end

  def test_two
    url_for(self.thumbnail)
  end

  def wtf
    return "A"
  end
end
