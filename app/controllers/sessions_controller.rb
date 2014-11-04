class SessionsController < ApplicationController

  # GET callback from facebook
  def create
    user = User.from_omniauth(auth_hash)

    reset_session
    session[:user_id] = user.id

    redirect_to root_path
  end

  def failure
    redirect_to root_path
  end

  def destroy
    reset_session

    redirect_to root_path
  end

  protected

  def auth_hash
    env["omniauth.auth"]
  end

end
