require 'rails_helper'

RSpec.describe Friendship, :type => :model do

  before do
    @user1 = User.create( :name => "A")
    @user2 = User.create( :name => "B")
    @user3 = User.create( :name => "C")
  end

  describe ".friends" do
    it "should have friends" do
      Friendship.create!( :user => @user1, :friend => @user2, :status => "confirmed" )
      expect(@user1.friends).to eq( [@user2] )
      expect(@user2.friends).to eq([])
    end

    it "should have inverse friends" do
      Friendship.create!( :user => @user1, :friend => @user2, :status => "confirmed" )
      expect(@user1.inverse_friends).to eq( [] )
      expect(@user2.inverse_friends).to eq( [@user1] )
    end
  end

  describe ".all_friends" do
    it "should return all friends" do
      Friendship.create!( :user => @user1, :friend => @user2, :status => "confirmed" )
      Friendship.create!( :user => @user3, :friend => @user1, :status => "confirmed" )

      expect(@user1.all_friends).to eq( [@user2, @user3])
    end
  end

  describe "is_friend?" do
    it "should return true if we're friend" do
      Friendship.create!( :user => @user1, :friend => @user2, :status => "confirmed" )
      expect(@user1.is_friend?(@user2)).to eq(true)
    end

    it "should return true if we're inverse friend" do
      Friendship.create!( :user => @user2, :friend => @user1, :status => "confirmed" )
      expect(@user1.is_friend?(@user2)).to eq(true)
    end

    it "should return false" do
      expect(@user1.is_friend?(@user3)).to eq(false)
    end
  end

  describe "pending_friendship?" do
    it "should return true if pending" do
      Friendship.create!( :user => @user1, :friend => @user2 )
      expect(@user1.pending_friendship?(@user2)).to eq(true)
    end

    it "should return true if pending" do
      Friendship.create!( :user => @user2, :friend => @user1 )
      expect(@user1.pending_friendship?(@user2)).to eq(false)
    end
  end

  describe "inverse_pending_friendship?" do
    it "should return true if pending" do
      Friendship.create!( :user => @user1, :friend => @user2 )
      expect(@user1.inverse_pending_friendship?(@user2)).to eq(false)
    end

    it "should return true if pending" do
      Friendship.create!( :user => @user2, :friend => @user1 )
      expect(@user1.inverse_pending_friendship?(@user2)).to eq(true)
    end
  end

  describe ".find_friendship" do
    it "should find frienship" do
      fs = Friendship.create!( :user => @user1, :friend => @user2 )
      expect( @user1.find_friendship(@user2) ).to eq(fs)
    end

    it "should find inverse friendship" do
      fs = Friendship.create!( :user => @user2, :friend => @user1 )
      expect( @user1.find_friendship(@user2) ).to eq(fs)
    end

  end

end
