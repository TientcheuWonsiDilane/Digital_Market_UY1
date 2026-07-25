class Store < ApplicationRecord
  belongs_to :user
  has_one_attached :logo
  has_many :items, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :conversations, dependent: :nullify

  validates :name, presence: true, length: { maximum: 100 }

  scope :search, ->(query) {
    return all if query.blank?
    where("name ILIKE :q OR description ILIKE :q", q: "%#{query}%")
  }
end
