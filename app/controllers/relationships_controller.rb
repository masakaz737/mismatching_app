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
    @matching_user, *@matching_score = User.find_matching_user(current_user) #マッチングユーザの呼び出し、およびマッチングスコアを配列にして代入
    @relationship = current_user.follow(@matching_user, @matching_score)
    unless @relationship.nil?
      redirect_to @relationship
    else
      @relationship = current_user.active_relationships.find_by(followed_id: @matching_user.id)
      redirect_to @relationship, notice: 'relationship was already existed.'
    end
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
