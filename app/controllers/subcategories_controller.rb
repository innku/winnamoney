class SubcategoriesController < ApplicationController
  
  before_filter :find_store, :only => [:show]
  before_filter :clear_register_session, :only => [:show]
  
  def index
    if params[:category_id]
      @subcategories = Category.find(params[:category_id]).subcategories
      respond_to do |format|
        format.js { render :json => @subcategories.collect {|sc| {:id => sc.id, :name => sc.name } }.to_json }
      end
    end
  end
  
  def show
    @subcategory = Subcategory.find(params[:id])
    @products = Product.tag_subcategory_id_is(params[:id]).all.paginate(:page => params[:page], :per_page => 12)
    render 'stores/show', :layout => 'stores'
  end
  
end