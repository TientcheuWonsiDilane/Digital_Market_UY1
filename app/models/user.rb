class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true, uniqueness: { case_sensitive: false },
                       length: { minimum: 3, maximum: 30 },
                       format: { with: /\A[a-zA-Z0-9_]+\z/, message: "ne doit contenir que des lettres, chiffres et underscores" }

  has_many :items, dependent: :destroy
  has_one :store, dependent: :destroy
  has_many :messages, dependent: :destroy

  has_many :sent_conversations, class_name: "Conversation", foreign_key: :sender_id, dependent: :destroy
  has_many :received_conversations, class_name: "Conversation", foreign_key: :recipient_id, dependent: :destroy

  def conversations
    Conversation.for_user(self)
  end

  def has_store?
    store.present?
  end
end
