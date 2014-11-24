require 'rails_helper'

RSpec.describe Friendship, :type => :model do

  before do
    @user1 = User.create( :name => "A")
    @user2 = User.create( :name => "B")
  end

  it "should have friends" do
    Friendship.create!( :user => @user1, :friend => @user2 )
    expect(@user1.friends).to eq( [@user2] )
    expect(@user2.friends).to eq([])
  end

  it "should have inverse friends" do
    Friendship.create!( :user => @user1, :friend => @user2 )
    expect(@user1.inverse_friends).to eq( [] )
    expect(@user2.inverse_friends).to eq( [@user1] )
  end

end
