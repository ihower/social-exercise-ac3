class UsersController < ApplicationController

  def switch
    user = User.find( params[:id] )
    reset_session
    session[:user_id] = user.id

    render :text => "this is bad"
  end

  def show
    @user = User.find( params[:id] )
  end

end
