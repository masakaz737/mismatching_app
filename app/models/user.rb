class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  mount_uploader :icon, ImageUploader

  has_one :questionnaire, dependent: :destroy

  validates :name, presence: true

  has_many :active_relationships, foreign_key: 'follower_id', class_name: 'Relationship', dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed

  has_many :passive_relationships, foreign_key: 'followed_id', class_name: 'Relationship', dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  has_many :notifications, dependent: :destroy
  has_many :messages, dependent: :destroy


  # (回答5 - 回答1) * 要素毎の設問数 * WEIGHT
  MAX_GAP = (5 - 1) * 4 * 10
  # (女2 - 男1) * 40 + (65歳 - 18歳) + (海外50 - 北海道1) + (学歴5 - 学歴1) * 10 + (職業5 - 職業1) * 10
  MAX_GAP_BACKGROUND = (2 - 1) * 40 + (65 - 18) + (50 - 1) + (5 - 1) * 10 * 2

  PERCENTAGE = 100 #100分率への変換

  #指定のユーザをフォローする
  def follow!(other_user,matching_score)
    @relationship = active_relationships.new(followed_id: other_user.id)
    if @relationship.save
      @relationship.update(
        total_score: matching_score[0], positive: matching_score[1],
        faithful: matching_score[2], cooperative: matching_score[3],
        mental: matching_score[4], curious: matching_score[5],
        background: matching_score[6]
      )
      @relationship
    end
  end

  #フォローしているかどうかを確認する
  def following?(other_user)
    following.include?(other_user)
  end

  def self.find_matching_user(user)
    @questionnaires = Questionnaire.all.order(:id)
    #各設問における他ユーザとの回答差を点数化した配列を取得
    @positive_points, @faithful_points, @cooperative_points, @mental_points,
    @curious_points = Questionnaire.questionnaire_calculation(user)
    @background_points = Questionnaire.background_calculation(user)

    total_points = [
      @positive_points, @faithful_points, @cooperative_points, @mental_points,
      @curious_points, @background_points
    ].transpose.map { |n| n.inject(:+) }

    #total_scoreが一番高いユーザーのインデックス番号を取得
    maximum = total_points.index(total_points.max)

    @matching_user = User.find(@questionnaires[maximum].user_id)
    #マッチングしたユーザとのマッチング度合いを項目毎に100分率にて計算
    @total_score = total_points.max * PERCENTAGE / (MAX_GAP * 5 + MAX_GAP_BACKGROUND)
    @positive_score = @positive_points[maximum] * PERCENTAGE / MAX_GAP
    @faithful_score = @faithful_points[maximum] * PERCENTAGE / MAX_GAP
    @cooperative_score = @cooperative_points[maximum] * PERCENTAGE / MAX_GAP
    @mental_score = @mental_points[maximum] * PERCENTAGE / MAX_GAP
    @curious_score = @curious_points[maximum] * PERCENTAGE / MAX_GAP
    @background_score = @background_points[maximum] * PERCENTAGE / MAX_GAP_BACKGROUND
    return @matching_user, @total_score, @positive_score, @faithful_score,
          @cooperative_score, @mental_score, @curious_score, @background_score
  end
end
