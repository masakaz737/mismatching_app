class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @questionnaire = Questionnaire.where(user_id: @user.id)
  end
end
