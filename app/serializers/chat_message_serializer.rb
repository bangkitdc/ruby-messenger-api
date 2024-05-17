class ChatMessageSerializer
  include FastJsonapi::ObjectSerializer

  set_type :chat_message

  attributes :id, :message, :sender, :sent_at

  attribute :sender do |chat_message|
    {
      id: chat_message.user.id,
      name: chat_message.user.name,
    }
  end

  attribute :sent_at do |chat_message|
    chat_message.created_at
  end

  attribute :conversation, if: Proc.new { |chat_message, params| params && params[:include_conversation] } do |chat_message|
    conversation = chat_message.conversation
    with_user = conversation.participants.where.not(user_id: chat_message.user.id).first.user

    {
      id: conversation.id,
      with_user: {
        id: with_user.id,
        name: with_user.name,
        photo_url: with_user.photo_url,
      },
    }
  end
end
