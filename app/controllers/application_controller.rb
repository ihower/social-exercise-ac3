class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  protected

  def require_login
    unless current_user
      flash[:alert] = "Login Required"
      redirect_to root_path
    end
  end

  def current_user
    User.find( session[:user_id] ) if session[:user_id]
  end

end
