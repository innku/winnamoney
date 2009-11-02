class CitiesController < ApplicationController
  def index
    @cities = City.like(params[:q])
    respond_to do |format|
      format.js {  }
    end
  end
end