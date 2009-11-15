class CitiesController < ApplicationController
  def index
    @cities = City.like(params[:q]).all
    respond_to do |format|
      format.js {  }
    end
  end
end