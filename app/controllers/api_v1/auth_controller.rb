class ApiV1::AuthController < ApiController

  before_action :require_login, :only => :logout

  def login
    if fb_user = User.verify_facebook_token(params[:access_token])
      auth_hash = {
        :uid => fb_user["id"],
        :info => {
          :name => fb_user["name"],
          :email => fb_user["email"]
        }
      }
      user = User.from_omniauth(auth_hash)

      render :json => { :message => "Ok",
                        :auth_token => user.token,
                        :user_id => user.id }
    else
      render :json => { :message => "Failed" }, :status => 401
    end
  end

  def logout
    current_user.setup_token
    current_user.save!

    render :json => { :message => "Ok" }
  end

end
