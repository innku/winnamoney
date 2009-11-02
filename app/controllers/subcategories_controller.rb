class SubcategoriesController < ApplicationController
  
  def index
    if params[:category_id]
      @subcategories = Category.find(params[:category_id]).subcategories
      respond_to do |format|
        format.js { render :json => @subcategories.collect {|sc| {:id => sc.id, :name => sc.name } }.to_json }
      end
    end
  end
  
end