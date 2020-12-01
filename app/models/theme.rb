class Theme < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :user, optional: true

  has_one_attached :top_border
  validates :top_border, attached: true, content_type: [:png, :jpg, :jpeg]

  has_one_attached :bottom_border
  validates :bottom_border, attached: true, content_type: [:png, :jpg, :jpeg]

  has_one_attached :background
  validates :background, attached: true, content_type: [:png, :jpg, :jpeg]

  has_one_attached :watermark
  validates :watermark, attached: true, content_type: [:png, :jpg, :jpeg]

  def top_border_url
    rails_blob_path(self.top_border) if self.top_border.attached?
  end

  def bottom_border_url
    rails_blob_path(self.bottom_border) if self.bottom_border.attached?
  end

  def background_url
    rails_blob_path(self.background) if self.background.attached?
  end

  def watermark_url
    rails_blob_path(self.watermark) if self.watermark.attached?
  end
end
