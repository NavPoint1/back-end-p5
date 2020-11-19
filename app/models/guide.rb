class Guide < ApplicationRecord
  belongs_to :author
  has_many :slides

  has_one_attached :thumbnail
end
