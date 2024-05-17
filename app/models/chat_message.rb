class ChatMessage < ApplicationRecord
  # Message can't be empty string
  validates :message, presence: true

  belongs_to :conversation
  belongs_to :user
end
