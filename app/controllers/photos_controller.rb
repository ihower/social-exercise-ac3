class PhotosController < ApplicationController

  before_action :require_login

  def create
    @photo = Photo.new( photo_params )
    @photo.user = current_user

    if @photo.save
      redirect_to :back
    else
      render "welcome/index"
    end
  end

  def destroy
    @photo = current_user.photos.find( params[:id] )
    @photo.destroy

    redirect_to :back
  end

  protected

  def photo_params
    params.require(:photo).permit(:description, :image)
  end

end
