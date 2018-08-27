class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def show
    @questionnaire = Questionnaire.find_by(user_id: @user.id)
  end

  def edit
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :show }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:biography, :icon, :icon_cache)
  end

  def ensure_correct_user
    if current_user.id != params[:id].to_i
      flash[:notice] = "権限がありません"
      redirect_to user_path(current_user)
    end
  end
end
