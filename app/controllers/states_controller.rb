class StatesController < ApplicationController
  def index
    @states = State.like(params[:q])
    respond_to do |format|
      format.js {  }
    end
  end
end