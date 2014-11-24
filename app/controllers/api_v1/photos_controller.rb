class ApiV1::PhotosController < ApplicationController

  def index
    @photos = Photo.page( params[:page] ).per(1)
  end

  def show
    @photo = Photo.find(params[:id])
  end

end
