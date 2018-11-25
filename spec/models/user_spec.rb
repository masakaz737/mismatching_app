require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
  end

  describe 'followメソッド' do
    before do
      @matching_score = [70, 30, 10, 40, 50, 60, 50]
    end

    # ユーザーをまだフォローしていない場合
    context 'when other_user is not my following' do
      it "follow other_user and return instance of Relationship" do
        follow = @user1.follow(@user2, @matching_score)
        expect(follow).to be_an_instance_of(Relationship)
      end
    end
    # ユーザーを既にフォローしている場合
    context 'when other_user has been arleady my following' do
      before do
        Relationship.create(follower_id: @user1.id, followed_id: @user2.id)
      end

      it "return nil" do
        follow = @user1.follow(@user2, @matching_score)
        expect(follow).to be_nil
      end
    end
  end

  describe 'following?メソッド' do
    # ユーザーをまだフォローしていない場合
    context 'when other_user is not my following' do
      it "return false" do
        judge = @user1.following?(@user2)
        expect(judge).to be false
      end
    end

    # ユーザーを既にフォローしている場合
    context 'when other_user has been arleady my following' do
      before do
        Relationship.create(follower_id: @user1.id, followed_id: @user2.id)
      end

      it "return true" do
        judge = @user1.following?(@user2)
        expect(judge).to be true
      end
    end
  end
end
