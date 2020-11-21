class Guide < ApplicationRecord
  belongs_to :user
  has_many :slides

  has_one_attached :thumbnail
end
