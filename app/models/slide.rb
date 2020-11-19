class Slide < ApplicationRecord
  belongs_to :guide
  belongs_to :user, through: :guide
end
