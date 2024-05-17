class ChatMessagesController < ApplicationController

  # POST /messages
  def create
    # Create conversation
    message_to = User.find_by(id: chat_message_params[:user_id])
    conversation = Conversation.new(title: message_to.name)

    # Create participants for the conversation
    participants = [
      Participant.new(user: current_user, conversation: conversation),
      Participant.new(user: message_to, conversation: conversation),
    ]

    # Start a transaction
    ActiveRecord::Base.transaction do
      # Save the conversation and participants
      conversation.save!
      participants.each(&:save!)

      # Create and save the chat message
      chat_message = ChatMessage.new(
        user: current_user,
        conversation: conversation,
        content: chat_message_params[:message],
      )
      chat_message.save!
    end

    render json: {
      message: "Operation successful",
      data: ChatMessageSerializer.new(chat_message).serialized_json,
    }, status: :created
  end

  private

  # Strong parameters
  def chat_message_params
    params.require(:chat_message).permit(
      :message,
      :user_id
    )
  end
end
