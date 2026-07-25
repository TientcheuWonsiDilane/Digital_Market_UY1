class Product < ApplicationRecord
  belongs_to :user
  belongs_to :store, optional: true
  has_rich_text :description
  has_many_attached :images

  validates :name, presence: true, length: { maximum: 200 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :category, presence: true
end
