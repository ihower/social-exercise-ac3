class ApiController < ActionController::Base

  helper_method :current_user

  before_action :check_token

  protected

  def check_token
    if params[:auth_token]
      @current_user = User.find_by_token(params[:auth_token])
    else
      @current_user = nil
    end
  end

  def require_login
    unless current_user
      render :json => { :message => "Requied login"}, :status => 401
    end
  end

  def current_user
    @current_user
  end

end
