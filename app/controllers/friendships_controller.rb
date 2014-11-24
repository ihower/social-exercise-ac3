class FriendshipsController < ApplicationController

  def create
    friend = User.find( params[:friend_id] )
    @friendship = current_user.friendships.create!( :friend => friend )

    redirect_to :back
  end

  def update
    @friendship = Friendship.find( params[:id] )

    # TODO: check permission
    @friendship.status = params[:status]
    @friendship.save!

    redirect_to :back
  end

  def destroy
    @friendship = Friendship.find( params[:id] )

    # TODO: check permission
    @friendship.destroy

    redirect_to :back
  end

end
