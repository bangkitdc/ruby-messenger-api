class Participant < ApplicationRecord
  self.primary_keys = :user_id, :conversation_id

  belongs_to :user
  belongs_to :conversation

  def mark_as_read
    update(last_read_at: Time.current)
  end
end
