class ConversationSerializer
  include FastJsonapi::ObjectSerializer

  set_type :conversation

  attribute :id
  attribute :with_user do |conversation, params|
    other_participant = conversation.other_participant(params[:current_user])
    {
      id: other_participant.id,
      name: other_participant.name,
      photo_url: other_participant.photo_url,
    }
  end

  attribute :last_message, if: Proc.new { |conversation| conversation.last_message.present? } do |conversation|
    {
      id: conversation.last_message.id,
      sender: {
        id: conversation.last_message.user.id,
        name: conversation.last_message.user.name,
      },
      sent_at: conversation.last_message.created_at,
    }
  end

  attribute :unread_count, if: Proc.new { |conversation, params| conversation.last_message.present? } do |conversation, params|
    conversation.unread_count(params[:current_user])
  end
end
