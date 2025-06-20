class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user

  validates :content, presence: true

  def from?(some_user)
    user == some_user
  end
end
