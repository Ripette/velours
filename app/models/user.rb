class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :partner, class_name: 'User', optional: true
  has_many :sent_favor_requests, class_name: 'FavorRequest', foreign_key: 'sender_id', dependent: :destroy
  has_many :received_favor_requests, class_name: 'FavorRequest', foreign_key: 'receiver_id', dependent: :destroy
  has_many :conversations, foreign_key: :sender_id, dependent: :destroy
  has_many :messages, dependent: :destroy

  validates :partner_email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true

  def partner
    User.find_by(email: partner_email) if partner_email.present?
  end

  def has_partner?
    partner_email.present? && partner.present?
  end

  def partner_name
    partner&.email&.split('@')&.first&.humanize || 'Votre partenaire'
  end

  def can_send_request_to?(user)
    return false if user == self
    return false unless has_partner?
    user.email == partner_email
  end
end
