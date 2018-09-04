class QuestionnairesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_questionnaire, only: %i[show edit update destroy]
  before_action :ensure_correct_user, only: %i[show edit update destroy]

  def new
    @user = User.find(params[:user_id])
    if @questionnaire
      @questionnaire = Questionnaire.new(@questionnaire)
    else
      @questionnaire = Questionnaire.new
    end
  end

  def edit
    @user = User.find(params[:user_id])
  end

  def create
    @questionnaire = Questionnaire.new(questionnaire_params)

    if @questionnaire.save
      redirect_to user_path(@questionnaire.user_id), notice: 'questionnaire was successfully created.'
    else
      @user = User.find(@questionnaire.user_id)
      render 'new'
    end
  end

  def update
    if @questionnaire.update(questionnaire_params)
      redirect_to user_path(@questionnaire.user_id), notice: 'questionnaire was
      successfully updated.'
    else
      render :edit
    end
  end

  private

  def set_questionnaire
    @questionnaire = Questionnaire.find(params[:id])
  end

  def questionnaire_params
    params.require(:questionnaire).permit(
      :sex, :birthday, :birthplace, :education, :job, :question1, :question2,
      :question3, :question4, :question5, :question6, :question7, :question8,
      :question9, :question10, :question11, :question12, :question13,
      :question14, :question15, :question16, :question17, :question18,
      :question19, :question20
    ).merge(user_id: params[:user_id])
  end

  def ensure_correct_user
    redirect_to user_path(current_user), notice: '権限がありません' if current_user.id != params[:user_id].to_i
  end
end
