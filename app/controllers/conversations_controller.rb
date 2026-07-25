class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @conversations = current_user.conversations
                                  .includes(:sender, :recipient, :messages)
                                  .order(updated_at: :desc)
  end

  def show
    @conversation = Conversation.find(params[:id])
    # Ensure user is part of this conversation
    unless @conversation.sender == current_user || @conversation.recipient == current_user
      redirect_to conversations_path, alert: "You cannot view this conversation."
      return
    end
    @messages = @conversation.messages.includes(:user).order(created_at: :asc)
    @message = Message.new
    # Mark unread messages as read
    @conversation.messages.where.not(user_id: current_user.id).where(read: false).update_all(read: true)
  end

  def create
    recipient = User.find(params[:recipient_id])
    store_id = params[:store_id]

    # Find or create conversation
    @conversation = Conversation.between(current_user, recipient).first

    unless @conversation
      @conversation = Conversation.create!(
        sender: current_user,
        recipient: recipient,
        store_id: store_id
      )
    end

    redirect_to @conversation
  end

  private

  def conversation_params
    params.permit(:recipient_id, :store_id)
  end
end
