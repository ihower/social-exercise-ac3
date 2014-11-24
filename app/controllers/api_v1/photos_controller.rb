class ApiV1::PhotosController < ApiController

  before_action :require_login

  def index
    @photos = Photo.page( params[:page] ).per(1)
  end

  def show
    @photo = Photo.find(params[:id])
  end

end
