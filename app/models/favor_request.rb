class FavorRequest < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  belongs_to :conversation
  has_one :convocation_detail, dependent: :destroy

  accepts_nested_attributes_for :convocation_detail

  validates :message, presence: true
  validates :category, presence: true

  enum status: { pending: 0, accepted: 1, declined: 2 }

  after_initialize :set_default_status, if: :new_record?

  # Catégories de désirs prédéfinies
  CATEGORIES = {
    'passion' => {
      icon: '🔥',
      title: 'Passion',
      subtitle: 'Scénario intense',
      conversation_title: 'Scénario de passion',
      color: '#DC143C'
    },
    'convocation' => {
      icon: '⚡',
      title: 'Convocation',
      subtitle: 'Commande personnalisée',
      conversation_title: 'Convocation',
      color: '#8B1538'
    },
    'sexto_hot' => {
      icon: '💋',
      title: 'Sexto Hot',
      subtitle: 'Message torride',
      conversation_title: 'Sexto Hot',
      color: '#FF1493'
    },
    'tu_es_a_moi' => {
      icon: '⛓️',
      title: 'Tu es à moi',
      subtitle: 'Scénario de domination',
      conversation_title: 'Domination',
      color: '#B22222'
    },
    'controle_moi' => {
      icon: '🎭',
      title: 'Contrôle moi',
      subtitle: 'Soumission volontaire',
      conversation_title: 'Contrôle',
      color: '#A52A2A'
    }
  }.freeze

  validates :category, inclusion: { in: CATEGORIES.keys }

  def category_info
    CATEGORIES[category] || {}
  end

  def category_icon
    category_info[:icon]
  end

  def category_title
    category_info[:title]
  end

  def category_subtitle
    category_info[:subtitle]
  end

  def category_color
    category_info[:color]
  end

  def category_conversation_title
    category_info[:conversation_title]
  end

  private

  def set_default_status
    self.status ||= :pending
  end

  def sender_and_receiver_must_be_different
    errors.add(:receiver, "ne peut pas être le même que l'expéditeur") if sender == receiver
  end
end
