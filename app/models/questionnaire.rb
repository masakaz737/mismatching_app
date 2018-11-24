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

  NORMAL_WEIGHT = 10 #質問1〜20、education、jobのマッチングスコアにおける比重
  SEX_WEIGHT = 40 #sexのマッチングスコアにおける比重
  BIRTH_WEIGHT = 1 #birthday、birthplaceのマッチングスコアにおける比重

  def self.background_calculation(user)
    @questionnaires = Questionnaire.all.order(:id)
    sex_points = []
    birthday_points = []
    birthplace_points = []
    education_points = []
    job_points = []

    @questionnaires.each do |q|
      sex_points.push(((user.questionnaire.sex_before_type_cast - q.sex_before_type_cast) * SEX_WEIGHT).abs)
      birthday_points.push(((user.questionnaire.age - q.age) * BIRTH_WEIGHT).abs)
      birthplace_points.push(((user.questionnaire.birthplace_before_type_cast - q.birthplace_before_type_cast) * BIRTH_WEIGHT).abs)
      education_points.push(((user.questionnaire.education_before_type_cast - q.education_before_type_cast) * NORMAL_WEIGHT).abs)
      job_points.push(((user.questionnaire.job_before_type_cast - q.job_before_type_cast) * NORMAL_WEIGHT).abs)
    end
    @background_points = [sex_points, birthday_points, birthplace_points, education_points, job_points].transpose.map{|n| n.inject(:+)}
    @background_points
  end

  def self.questionnaire_calculation(user)
    for i in 1..20 do
      var = "@score#{i}"
      eval("#{var} = #{Array.new}")
    end

    @questionnaires = Questionnaire.all.order(:id)
    @questionnaires.each do |q|
      @score1.push((user.questionnaire.question1 - q.question1).abs)
      @score2.push((user.questionnaire.question2 - q.question2).abs)
      @score3.push((user.questionnaire.question3 - q.question3).abs)
      @score4.push((user.questionnaire.question4 - q.question4).abs)
      @score5.push((user.questionnaire.question5 - q.question5).abs)
      @score6.push((user.questionnaire.question6 - q.question6).abs)
      @score7.push((user.questionnaire.question7 - q.question7).abs)
      @score8.push((user.questionnaire.question8 - q.question8).abs)
      @score9.push((user.questionnaire.question9 - q.question9).abs)
      @score10.push((user.questionnaire.question10 - q.question10).abs)
      @score11.push((user.questionnaire.question11 - q.question11).abs)
      @score12.push((user.questionnaire.question12 - q.question12).abs)
      @score13.push((user.questionnaire.question13 - q.question13).abs)
      @score14.push((user.questionnaire.question14 - q.question14).abs)
      @score15.push((user.questionnaire.question15 - q.question15).abs)
      @score16.push((user.questionnaire.question16 - q.question16).abs)
      @score17.push((user.questionnaire.question17 - q.question17).abs)
      @score18.push((user.questionnaire.question18 - q.question18).abs)
      @score19.push((user.questionnaire.question19 - q.question19).abs)
      @score20.push((user.questionnaire.question20 - q.question20).abs)
    end
    @positive_points = [@score1, @score6, @score11, @score16].transpose.map{|n| n.inject(:+) * NORMAL_WEIGHT}
    @faithful_points = [@score2, @score7, @score12, @score17].transpose.map{|n| n.inject(:+) * NORMAL_WEIGHT}
    @cooperative_points = [@score3, @score8, @score13, @score18].transpose.map{|n| n.inject(:+) * NORMAL_WEIGHT}
    @mental_points = [@score4, @score9, @score14, @score19].transpose.map{|n| n.inject(:+) * NORMAL_WEIGHT}
    @curious_points = [@score5, @score10, @score15, @score20].transpose.map{|n| n.inject(:+) * NORMAL_WEIGHT}
    return @positive_points, @faithful_points, @cooperative_points, @mental_points, @curious_points
  end
end
