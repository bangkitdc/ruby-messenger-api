class User < ApplicationRecord
  # encrypt password
  has_secure_password

  has_many :participants
  has_many :chat_messages
  has_many :conversations, through: :participants

  def self.generate
    create(name: Faker::Name.name, email: Faker::Internet.email, password_digest: "test")
  end

  def mark_conversation_as_read(conversation)
    participant = participants.find_by(conversation: conversation)
    participant&.mark_as_read
  end
end
