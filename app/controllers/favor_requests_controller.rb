class FavorRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_favor_request, only: [:show, :accept, :decline, :destroy]
  before_action :ensure_partner_setup, only: [:index, :new, :create]
  layout 'setup', only: [:setup_partner]

  def index
    @partner = current_user.partner
    if @partner
      sent = current_user.sent_favor_requests.where(receiver_id: @partner.id)
      received = current_user.received_favor_requests.where(sender_id: @partner.id)
      @notifications = (sent + received).sort_by(&:created_at).reverse
    else
      @notifications = []
    end
    @categories = FavorRequest::CATEGORIES
  end

  def new
    @favor_request = FavorRequest.new
    @categories = FavorRequest::CATEGORIES
    @partner = current_user.partner

    unless @partner
      redirect_to setup_partner_path, alert: 'Vous devez d\'abord configurer votre partenaire.'
    end

    # Pré-remplir la catégorie si elle est passée en paramètre
    if params[:category] && @categories.key?(params[:category])
      @favor_request.category = params[:category]
      @favor_request.build_convocation_detail if @favor_request.category == 'convocation'
    end
  end

  def create
    @partner = current_user.partner
    @favor_request = current_user.sent_favor_requests.build(favor_request_params)
    @favor_request.receiver = @partner

    # Always create a new conversation for each new favor request
    @conversation = Conversation.create!(
      sender_id: current_user.id,
      recipient_id: @partner.id,
      topic: @favor_request.category_conversation_title
    )
    @favor_request.conversation = @conversation

    if @favor_request.save
      # Add the favor request details as the first message in the conversation
      initial_message = "Nouvelle demande : #{helpers.format_favor_request_details(@favor_request)}"
      @conversation.messages.create(user: current_user, content: initial_message)

      flash[:notice] = "Votre désir a bien été envoyé à #{@partner.email.split('@').first.humanize}."
      redirect_to conversation_path(@conversation)
    else
      # If saving fails, the conversation is already created and will be orphaned.
      # It's better to destroy it to keep the database clean.
      @conversation.destroy
      @categories = FavorRequest::CATEGORIES
      @partner = current_user.partner
      render :new, status: :unprocessable_entity
    end
  end

  def show
    unless @favor_request.sender == current_user || @favor_request.receiver == current_user
      redirect_to favor_requests_path, alert: 'Accès non autorisé.'
    end
  end

  def accept
    if @favor_request.receiver == current_user && @favor_request.pending?
      @favor_request.update(status: 'accepted')
      redirect_to favor_requests_path, notice: '💖 Demande acceptée avec plaisir !'
    else
      redirect_to favor_requests_path, alert: 'Action non autorisée.'
    end
  end

  def decline
    if @favor_request.receiver == current_user && @favor_request.pending?
      @favor_request.update(status: 'declined')
      redirect_to favor_requests_path, notice: '💔 Demande poliment refusée.'
    else
      redirect_to favor_requests_path, alert: 'Action non autorisée.'
    end
  end

  def setup_partner_form
    # This action just renders the form
  end

  def create_partner
    partner_email = params[:partner_email]

    if partner_email.blank?
      flash.now[:alert] = 'Veuillez entrer un email valide.'
      render :setup_partner_form and return
    end

    if partner_email.downcase == current_user.email.downcase
      flash.now[:alert] = 'Vous ne pouvez pas être votre propre partenaire.'
      render :setup_partner_form and return
    end

    partner = User.find_by('lower(email) = ?', partner_email.downcase)

    if partner
      if partner.has_partner? && partner.partner != current_user
        flash.now[:alert] = "Cet utilisateur est déjà connecté à un autre partenaire."
        render :setup_partner_form
      else
        current_user.update(partner_email: partner.email)
        partner.update(partner_email: current_user.email)
        redirect_to favor_requests_path, notice: "Vous êtes maintenant connecté à #{partner.email.split('@').first.humanize} !"
      end
    else
      flash.now[:alert] = 'Aucun utilisateur trouvé avec cet email. Assurez-vous que votre partenaire a bien créé un compte.'
      render :setup_partner_form
    end
  end

  def disconnect_partner
    partner = current_user.partner
    if partner
      partner.update(partner_email: nil)
      current_user.update(partner_email: nil)
      redirect_to favor_requests_path, notice: "Vous avez bien été déconnecté de votre partenaire."
    else
      redirect_to favor_requests_path, alert: "Aucun partenaire à déconnecter."
    end
  end

  def destroy
    @favor_request.destroy
    respond_to do |format|
      format.html { redirect_to favor_requests_path, notice: 'Notification supprimée.' }
      format.turbo_stream { render turbo_stream: turbo_stream.remove("notification-#{@favor_request.id}") }
      format.js { render inline: "document.getElementById('notification-#{@favor_request.id}').remove();" }
      format.json { head :no_content }
    end
  end

  private

  def set_favor_request
    @favor_request = FavorRequest.find(params[:id])
  end

  def favor_request_params
    params.require(:favor_request).permit(
      :category, :message,
      convocation_detail_attributes: [:location, :timing, :attire, :mood]
    )
  end

  def ensure_partner_setup
    unless current_user.has_partner?
      redirect_to setup_partner_favor_requests_path
    end
  end
end
