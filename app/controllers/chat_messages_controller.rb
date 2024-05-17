class ChatMessagesController < ApplicationController
  # POST /messages
  def create
    # Create conversation
    message_to = User.find_by(id: chat_message_params[:user_id])

    if message_to.nil?
      raise ActiveRecord::RecordNotFound, "User to message not found"
    end

    # Check if conversation already exists between current_user and message_to
    conversation = find_existing_conversation(current_user, message_to)

    unless conversation
      conversation = Conversation.new(title: "Conversation between #{current_user.name} and #{message_to.name}")

      # Create participants for the conversation
      participants = [
        Participant.new(user: current_user, conversation: conversation),
        Participant.new(user: message_to, conversation: conversation),
      ]

      # Start a transaction to save the conversation and participants
      ActiveRecord::Base.transaction do
        conversation.save!
        participants.each(&:save!)
      end
    end

    # Create and save the chat message
    chat_message = ChatMessage.new(
      user: current_user,
      conversation: conversation,
      message: chat_message_params[:message],
    )

    chat_message.save!

    render json: {
      message: "Operation successful",
      data: serialize_message(chat_message, false),
    }, status: :created
  end

  private

  # Strong parameters
  def chat_message_params
    params.require(:chat_message).permit(:message, :user_id)
  end

  # Serializer
  def serialize_message(records, collection = true)
    if collection
      records.map { |record|
        ChatMessageSerializer.new(
          record,
          { params: { include_conversation: true } }
        ).serializable_hash[:data][:attributes]
      }
    else
      ChatMessageSerializer.new(
        records,
        { params: { include_conversation: true } }
      ).serializable_hash[:data][:attributes]
    end
  end

  # Find existing conversation between two users
  def find_existing_conversation(user1, user2)
    user1_conversations = Participant.where(user: user1).pluck(:conversation_id)
    Participant.where(user: user2, conversation_id: user1_conversations).map(&:conversation).first
  end
end
