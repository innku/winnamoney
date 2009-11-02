class TagsController < ApplicationController
  def index
    if params[:subcategory_id]
      @tags = Subcategory.find(params[:subcategory_id]).tags
      respond_to do |format|
        format.js { render :json => @tags.collect {|t| {:id => t.id, :name => t.name } }.to_json }
      end
    end
  end
end