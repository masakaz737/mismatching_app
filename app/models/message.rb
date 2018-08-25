class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user
  belongs_to :message_recipient, class_name: 'User'

  validates_presence_of :body, :conversation_id, :user_id, :message_recipient_id
  def message_time
    created_at.strftime("%m/%d/%y at %l:%M %p")
  end
end
