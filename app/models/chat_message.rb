class ChatMessage < ApplicationRecord
  # Content can't be empty string
  validates :content, presence: true

  belongs_to :conversation
  belongs_to :user
end
