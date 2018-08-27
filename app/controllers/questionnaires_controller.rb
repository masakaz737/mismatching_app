class QuestionnairesController < ApplicationController
  before_action :set_questionnaire, only: [:show, :edit, :update, :destroy]

  # GET /questions
  # GET /questions.json
  def index
    @questionnaires = Questionnaire.all
  end

  # GET /questions/1
  # GET /questions/1.json
  def show
    @questionnaire = Questionnaire.find(user_id: params[:user_id])
  end

  # GET /questions/new
  def new
    @user = User.find(params[:user_id])
    @questionnaire = Questionnaire.new
  end

  # GET /questions/1/edit
  def edit
    @user = User.find(params[:user_id])
  end

  # POST /questions
  # POST /questions.json
  def create
    @questionnaire = Questionnaire.new(questionnaire_params)

      if @questionnaire.save
        redirect_to user_path(@questionnaire.user_id), notice: 'questionnaire was successfully created.'
      else
        # できたらrenderにしたい
        redirect_to new_user_questionnaire_path
      end
  end

  # PATCH/PUT /questions/1
  # PATCH/PUT /questions/1.json
  def update
    respond_to do |format|
      if @questionnaire.update(questionnaire_params)
        format.html { redirect_to user_path(@questionnaire.user_id), notice: 'questionnaire was successfully updated.' }
        format.json { render :show, status: :ok, location: @questionnaire }
      else
        format.html { render :edit }
        format.json { render json: @questionnaire.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @questionnaire.destroy
    respond_to do |format|
      format.html { redirect_to questionnaires_url, notice: 'questionnaire was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_questionnaire
    @questionnaire = Questionnaire.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def questionnaire_params
    params.require(:questionnaire).permit(:sex, :birthday, :birthplace, :education, :job,
                                :question1, :question2, :question3, :question4, :question5,
                                :question6, :question7, :question8, :question9, :question10,
                                :question11, :question12, :question13, :question14, :question15,
                                :question16, :question17, :question18, :question19, :question20)
                                .merge(user_id: params[:user_id])
  end
end
