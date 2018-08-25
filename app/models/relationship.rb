class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  validates :follower_id, presence: true
  validates :followed_id, presence: true

  validates_uniqueness_of :follower_id, scope: :followed_id

  has_many :notifications, dependent: :destroy

  scope :between, -> (follower_id,followed_id) do
    where("(relationships.follower_id = ? AND relationships.followed_id =?) OR (relationships.follower_id = ? AND  relationships.followed_id =?)", follower_id,followed_id, followed_id, follower_id)
  end
end
