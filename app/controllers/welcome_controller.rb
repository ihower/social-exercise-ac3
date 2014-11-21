class WelcomeController < ApplicationController

  def index
    @photos = Photo.page(params[:page]).per(5)
  end

end
