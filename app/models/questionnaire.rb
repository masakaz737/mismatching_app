class Questionnaire < ApplicationRecord
  belongs_to :user

  validates_presence_of :sex, :birthday, :birthplace, :education, :job,
    :question1, :question2, :question3, :question4, :question5, :question6,
    :question7, :question8, :question9, :question10, :question11, :question12,
    :question13, :question14, :question15, :question16, :question17, :question18,
    :question19, :question20

  def age
    date_format = '%Y%m%d'
    (Date.today.strftime(date_format).to_i - birthday.strftime(date_format).to_i) / 10000
  end

  enum birthplace: {
    北海道: 1, 青森県: 2, 岩手県: 3, 宮城県: 4, 秋田県: 5, 山形県: 6, 福島県: 7,
    茨城県: 8, 栃木県: 9, 群馬県: 10, 埼玉県: 11, 千葉県: 12, 東京都: 13, 神奈川県: 14,
    新潟県: 15, 富山県: 16, 石川県: 17, 福井県: 18, 山梨県: 19, 長野県: 20,
    岐阜県: 21, 静岡県: 22, 愛知県: 23, 三重県: 24,
    滋賀県: 25, 京都府: 26, 大阪府: 27, 兵庫県: 28, 奈良県: 29, 和歌山県: 30,
    鳥取県: 31, 島根県: 32, 岡山県: 33, 広島県: 34, 山口県: 35,
    徳島県: 36, 香川県: 37, 愛媛県: 38, 高知県: 39,
    福岡県: 40, 佐賀県: 41, 長崎県: 42, 熊本県: 43, 大分県: 44, 宮崎県: 45, 鹿児島県: 46, 沖縄県: 47,
    海外: 50
  }

  enum sex: { 男: 1, 女: 2 }
  enum education: { 高卒: 1, 短大、専門卒: 2, 大卒: 3, 院卒: 4, その他: 5 }
  enum job: { 無職: 1, 学生: 2, 会社員: 3, フリーランス: 4, 経営者: 5 }
end
