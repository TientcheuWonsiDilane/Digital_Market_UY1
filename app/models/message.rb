class Message < ApplicationRecord
  belongs_to :conversation, touch: true
  belongs_to :user

  validates :body, presence: true

  after_create_commit :mark_conversation_unread

  private

  def mark_conversation_unread
    # Mark as unread for the other user - handled in the conversation show
  end
end
