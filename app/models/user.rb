class User < ApplicationRecord
    has_many :guides
    has_many :slides, through: :guides

    has_many :likes
    has_many :guides, through: :likes
    
    has_one_attached :avatar
    has_secure_password

    validates :username, presence: true
    validates :username, uniqueness: true
    validates :username, length: { minimum: 4 }
    validates :email, presence: true
    validates :email, uniqueness: true
    
    validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
end
