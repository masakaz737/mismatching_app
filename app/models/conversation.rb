class Conversation < ApplicationRecord
  # 会話はUserの概念をsenderとrecipientに分けた形でアソシエーションする。
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'
  belongs_to :recipient, foreign_key: :recipient_id, class_name: 'User'
  # 一つの会話はメッセージをたくさん含む一対多。
  has_many :messages, dependent: :destroy

  # [:sender_id, :recipient_id]が同じ組み合わせで保存されないようにするためのバリデーションを設定。
  validates_uniqueness_of :sender_id, scope: :recipient_id

  scope :between, -> (sender_id,recipient_id) do
    where("(conversations.sender_id = ? AND conversations.recipient_id =?) OR (conversations.sender_id = ? AND  conversations.recipient_id =?)", sender_id,recipient_id, recipient_id, sender_id)
  end

  def target_user(current_user)
    if sender_id == current_user.id
      User.find(recipient_id)
    elsif recipient_id == current_user.id
      User.find(sender_id)
    end
  end
end
