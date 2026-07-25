class Item < ApplicationRecord
  belongs_to :user
  belongs_to :store, optional: true
  has_rich_text :description
  has_many_attached :images

  validates :name, presence: true, length: { maximum: 200 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :category, presence: true

  scope :search, ->(query) {
    return all if query.blank?
    where("name ILIKE :q OR category ILIKE :q", q: "%#{query}%")
  }

  scope :by_category, ->(category) {
    return all if category.blank?
    where(category: category)
  }

  def self.categories
    distinct.pluck(:category).compact.sort
  end
end
