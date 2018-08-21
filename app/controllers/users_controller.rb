class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @questionnaire = Questionnaire.find_by(user_id: @user.id)
  end
end
