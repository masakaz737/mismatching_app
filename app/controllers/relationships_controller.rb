class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_relationship, only: %i[show edit update destroy]
  before_action :ensure_correct_user, only: [:show]
  after_action :create_notifications, only: [:create]

  def show
    if @relationship.follower_id == current_user.id
      @matching_user = User.find(@relationship.followed_id)
    else
      @matching_user = User.find(@relationship.follower_id)
    end
  end

  def new
    @relationship = Relationship.new
  end

  def create
    find_matching_user
    @relationship = current_user.follow!(@matching_user)
    if @relationship.save
      @relationship.update(
        total_score: @total_score, positive: @positive_score,
        faithful: @faithful_score, cooperative: @cooperative_score,
        mental: @mental_score, curious: @curious_score,
        background: @background_score
      )
      redirect_to relationship_path(@relationship.id)
    else
      redirect_to relationship_path(
        Relationship.find_by(follower_id: current_user.id, followed_id: @matching_user.id).id
      ), notice: 'relationship was already existed.'
    end
  end

  def background_calculation
    @questionnaires = Questionnaire.all.order(:id)
    sex_points = []
    birthday_points = []
    birthplace_points = []
    education_points = []
    job_points = []

    @questionnaires.each do |questionnaire|
      sex_points.push(((current_user.questionnaire.sex_before_type_cast - questionnaire.sex_before_type_cast) * 40).abs)
      birthday_points.push(((current_user.questionnaire.age - questionnaire.age) * 1).abs)
      birthplace_points.push(((current_user.questionnaire.birthplace_before_type_cast - questionnaire.birthplace_before_type_cast) * 1).abs)
      education_points.push(((current_user.questionnaire.education_before_type_cast - questionnaire.education_before_type_cast) * 10).abs)
      job_points.push(((current_user.questionnaire.job_before_type_cast - questionnaire.job_before_type_cast) * 10).abs)
    end
    @background_points = [sex_points, birthday_points, birthplace_points, education_points, job_points].transpose.map{|n| n.inject(:+)}
  end

  def questionnaire_calculation
    for i in 1..20 do
      var = "@score#{i}"
      eval("#{var} = #{Array.new}")
    end

    @questionnaires = Questionnaire.all.order(:id)
    weight = 10
    @questionnaires.each do |questionnaire|
      @score1.push(((current_user.questionnaire.question1 - questionnaire.question1).abs) * weight)
      @score2.push(((current_user.questionnaire.question2 - questionnaire.question2).abs) * weight)
      @score3.push(((current_user.questionnaire.question3 - questionnaire.question3).abs) * weight)
      @score4.push(((current_user.questionnaire.question4 - questionnaire.question4).abs) * weight)
      @score5.push(((current_user.questionnaire.question5 - questionnaire.question5).abs) * weight)
      @score6.push(((current_user.questionnaire.question6 - questionnaire.question6).abs) * weight)
      @score7.push(((current_user.questionnaire.question7 - questionnaire.question7).abs) * weight)
      @score8.push(((current_user.questionnaire.question8 - questionnaire.question8).abs) * weight)
      @score9.push(((current_user.questionnaire.question9 - questionnaire.question9).abs) * weight)
      @score10.push(((current_user.questionnaire.question10 - questionnaire.question10).abs) * weight)
      @score11.push(((current_user.questionnaire.question11 - questionnaire.question11).abs) * weight)
      @score12.push(((current_user.questionnaire.question12 - questionnaire.question12).abs) * weight)
      @score13.push(((current_user.questionnaire.question13 - questionnaire.question13).abs) * weight)
      @score14.push(((current_user.questionnaire.question14 - questionnaire.question14).abs) * weight)
      @score15.push(((current_user.questionnaire.question15 - questionnaire.question15).abs) * weight)
      @score16.push(((current_user.questionnaire.question16 - questionnaire.question16).abs) * weight)
      @score17.push(((current_user.questionnaire.question17 - questionnaire.question17).abs) * weight)
      @score18.push(((current_user.questionnaire.question18 - questionnaire.question18).abs) * weight)
      @score19.push(((current_user.questionnaire.question19 - questionnaire.question19).abs) * weight)
      @score20.push(((current_user.questionnaire.question20 - questionnaire.question20).abs) * weight)
    end
    @positive_points = [@score1, @score6, @score11, @score16].transpose.map{|n| n.inject(:+)}
    @faithful_points = [@score2, @score7, @score12, @score17].transpose.map{|n| n.inject(:+)}
    @cooperative_points = [@score3, @score8, @score13, @score18].transpose.map{|n| n.inject(:+)}
    @mental_points = [@score4, @score9, @score14, @score19].transpose.map{|n| n.inject(:+)}
    @curious_points = [@score5, @score10, @score15, @score20].transpose.map{|n| n.inject(:+)}
  end

  def find_matching_user
    questionnaire_calculation
    background_calculation

    total_points = [
      @positive_points, @faithful_points, @cooperative_points, @mental_points,
      @curious_points, @background_points
    ].transpose.map { |n| n.inject(:+) }
    maximum = total_points.index(total_points.max)

    # (回答5 - 回答1) * 要素毎の設問数 * weight
    max_gap = (5 - 1) * 4 * 10
    # (女2 - 男1) * 40 + (65歳 - 18歳) + (海外50 - 北海道1) + (学歴5 - 学歴1) * 10 + (職業5 - 職業1) * 10
    max_gap_background = (2 - 1) * 40 + (65 - 18) + (50 - 1) + (5 - 1) * 10 * 2

    @matching_user = User.find(@questionnaires[maximum].user_id)
    @total_score = total_points.max * 100 / (max_gap * 5 + max_gap_background)
    @positive_score = @positive_points[maximum] * 100 / max_gap
    @faithful_score = @faithful_points[maximum] * 100 / max_gap
    @cooperative_score = @cooperative_points[maximum] * 100 / max_gap
    @mental_score = @mental_points[maximum] * 100 / max_gap
    @curious_score = @curious_points[maximum] * 100 / max_gap
    @background_score = @background_points[maximum] * 100 / max_gap_background
  end

  private

  def set_relationship
    @relationship = Relationship.find(params[:id])
  end

  def create_notifications
    Notification.create(
      user_id: @relationship.followed_id,
      notified_by_id: @relationship.follower_id,
      relationship_id: @relationship.id
    )
  end

  def ensure_correct_user
    redirect_to user_path(current_user), notice: '権限がありません' if current_user.id != @relationship.follower_id && current_user.id != @relationship.followed_id
  end
end
