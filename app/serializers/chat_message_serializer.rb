class ChatMessageSerializer
  include FastJsonapi::ObjectSerializer

  set_type :chat_message

  attributes :id, :message, :sender, :sent_at

  attribute :message do |chat_message|
    chat_message.content
  end

  attribute :sender do |chat_message|
    {
      id: chat_message.user.id,
      name: chat_message.user.name,
    }
  end

  attribute :sent_at do |chat_message|
    chat_message.created_at
  end
end
