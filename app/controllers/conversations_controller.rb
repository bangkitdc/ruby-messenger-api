class ConversationsController < ApplicationController
  before_action :authorize_conversation, only: [:show, :update, :destroy, :messages]

  # GET /conversations
  def index
    render json: {
      message: "Operation successful",
      data: serialize_conversation(conversations, true),
    }, status: :ok
  end

  # GET /conversations/:id
  def show
    # Update unread_count if user clicks the conversation
    current_user.mark_conversation_as_read(conversation)

    render json: {
      message: "Operation successful",
      data: serialize_conversation(conversation, false),
    }, status: :ok
  end

  # POST /conversations
  def create
    # Better to make transactions
    # :)

    conversation = Conversation.new(conversation_params)
    if conversation.save
      # Create participants (members)
      participant = Participant.create(user: current_user, conversation: conversation)

      # For testing only: use users with id = 1
      Participant.create(user_id: 1, conversation_id: participant.conversation_id)

      if participant.persisted?
        render json: {
          message: "Conversation created successfully",
          data: serialize_conversation(conversation, false),
        }, status: :created
      else
        render json: {
          message: "Internal server error",
        }, status: :internal_server_error
      end
    else
      render json: {
        message: "Operation unsuccessful",
        errors: { conversation: ["Unprocessable entity"] },
      }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /conversations/:id
  def update
    if conversation.update(conversation_params)
      render json: {
        message: "Conversation updated successfully",
        data: serialize_conversation(conversation, false),
      }, status: :ok
    else
      render json: {
        message: "Operation unsuccessful",
        errors: { conversation: ["Unprocessable entity"] },
      }, status: :unprocessable_entity
    end
  end

  # DELETE /conversations/:id
  def destroy
    # Already using cascade
    if conversation.destroy
      render json: {
        message: "Conversation deleted successfully",
      }, status: :ok
    else
      render json: {
        message: "Operation unsuccessful",
      }, status: :unprocessable_entity
    end
  end

  # GET /conversations/:conversation_id/messages
  def messages
    render json: {
      message: "Operation successful",
      data: serialize_message(chat_messages, true),
    }, status: :ok
  end

  private

  # -------------------------- Conversation -------------------------- #
  # Get all conversations
  def conversations
    @conversations ||= Conversation
      .joins(:participants)
      .where(
        participants: { user_id: current_user.id },
      ).distinct
  end

  # Get conversation by id
  def conversation
    @conversation ||= Conversation.find_by(id: params[:id])
  end

  # Parameters
  def conversation_params
    params.require(:conversation).permit(
      :title
    )
  end

  # Serializer
  def serialize_conversation(records, collection = true)
    if collection
      records.map { |record|
        ConversationSerializer.new(
          record,
          params: { current_user: current_user },
        ).serializable_hash[:data][:attributes]
      }
    else
      ConversationSerializer.new(
        records,
        params: { current_user: current_user },
      ).serializable_hash[:data][:attributes]
    end
  end

  # -------------------------- Conversation -------------------------- #
  # Get all messages from the conversation
  def chat_messages
    @chat_messages ||= conversation.chat_messages.order(created_at: :asc)
  end

  # Serializer
  def serialize_message(records, collection = true)
    if collection
      records.map { |record|
        ChatMessageSerializer.new(
          record
        ).serializable_hash[:data][:attributes]
      }
    else
      ChatMessageSerializer.new(
        records
      ).serializable_hash[:data][:attributes]
    end
  end

  # -------------------------- Controller Action -------------------------- #
  # Better to use middleware, but I don't know how to do it in Rails
  def authorize_conversation
    conversation = Conversation.find_by(id: params[:id])

    # Check availability
    # Better to use throw and then having exception handler wrap the application
    if !conversation
      render json: {
        message: "Conversation not found",
      }, status: :not_found
      return
    end

    # Check authority
    # Better to use throw and then having exception handler wrap the application
    isInTheConversation = Participant.find_by(user: current_user, conversation: conversation)
    unless conversation && isInTheConversation
      render json: {
        message: "Invalid credentials",
      }, status: :forbidden
      return
    end
  end
end
