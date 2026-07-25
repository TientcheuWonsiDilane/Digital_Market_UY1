class Conversation < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :recipient, class_name: "User"
  belongs_to :store, optional: true
  has_many :messages, dependent: :destroy

  validates :sender_id, uniqueness: { scope: :recipient_id, message: "Conversation already exists" }

  scope :for_user, ->(user) { where("sender_id = ? OR recipient_id = ?", user.id, user.id) }
  scope :between, ->(user1, user2) {
    where(
      "(sender_id = ? AND recipient_id = ?) OR (sender_id = ? AND recipient_id = ?)",
      user1.id, user2.id, user2.id, user1.id
    )
  }

  def other_user(current_user)
    sender == current_user ? recipient : sender
  end

  def unread_count_for(user)
    messages.where("user_id != ? AND read = ?", user.id, false).count
  end
end
