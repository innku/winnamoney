class CategoriesController < ApplicationController
  def create
    @category = Category.new(:name => params[:name])
    if @category.save
      respond_to do |format|
        format.js { render :json => {:id => @category.id, :name => @category.name}.to_json }
      end
    end
  end
end