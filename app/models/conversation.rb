class Conversation < ApplicationRecord
  # Title can't be empty string
  validates :title, presence: true

  has_many :participants
  has_many :chat_messages
  has_many :users, through: :participants

  # Get other user info
  # Note: this is only available for personal chat messages
  def other_participant(current_user)
    users.where.not(id: current_user.id).first
  end

  # Get latest message
  def last_message
    chat_messages.order(created_at: :desc).first
  end

  # Get unread count
  def unread_count(user)
    participant = participants.find_by(user_id: user.id)
    return 0 unless participant

    if participant.last_read_at
      chat_messages.where("created_at > ?", participant.last_read_at).count
    else
      chat_messages.count
    end
  end
end
