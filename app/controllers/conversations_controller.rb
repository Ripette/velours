class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @conversations = Conversation.where("sender_id = ? OR recipient_id = ?", current_user.id, current_user.id)
  end

  def show
    @conversation = Conversation.find(params[:id])
    # Ensure the current user is part of the conversation
    unless @conversation.sender == current_user || @conversation.recipient == current_user
      redirect_to root_path, alert: "Accès non autorisé."
      return
    end

    @messages = @conversation.messages.order(created_at: :asc)
    @message = @conversation.messages.build
  end
end
