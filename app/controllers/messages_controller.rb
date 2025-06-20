class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation

  def create
    @message = @conversation.messages.build(message_params)
    @message.user = current_user

    if @message.save
      redirect_to conversation_path(@conversation)
    else
      # Handle failure, maybe render the conversation show page with an error
      # For simplicity, we'll just redirect for now.
      flash[:alert] = "Votre message n'a pas pu être envoyé."
      redirect_to conversation_path(@conversation)
    end
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
    # Optional: Add another security check to ensure the user is part of the conversation
    unless @conversation.sender == current_user || @conversation.recipient == current_user
      redirect_to root_path, alert: "Accès non autorisé."
    end
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
