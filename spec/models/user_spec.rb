require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user1 = create(:user)
    @user2 = create(:user)
  end

  describe 'followメソッド' do
    before do
      @matching_score = [70, 30, 10, 40, 50, 60, 50]
    end

    # ユーザーをまだフォローしていない場合
    context 'when other_user is not my following' do
      it "follow other_user and return instance of Relationship" do
        follow = @user1.follow(@user2, @matching_score)
        expect(follow.follower_id).to eq(@user1.id)
        expect(follow.followed_id).to eq(@user2.id)
        expect(follow.total_score).to eq(@matching_score[0])
        expect(follow.positive).to eq(@matching_score[1])
        expect(follow.faithful).to eq(@matching_score[2])
        expect(follow.cooperative).to eq(@matching_score[3])
        expect(follow.mental).to eq(@matching_score[4])
        expect(follow.curious).to eq(@matching_score[5])
        expect(follow.background).to eq(@matching_score[6])
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
        expect(@user1.following?(@user2)).to be_falsey
      end
    end

    # ユーザーを既にフォローしている場合
    context 'when other_user has been arleady my following' do
      before do
        Relationship.create(follower_id: @user1.id, followed_id: @user2.id)
      end

      it "return true" do
        expect(@user1.following?(@user2)).to be_truthy
      end
    end
  end
end
