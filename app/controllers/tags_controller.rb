class TagsController < ApplicationController
  
  before_filter :clear_register_session, :only => [:show]
  before_filter :find_cart, :only => [:show]
  before_filter :shopping_action!, :only => 'show'
  
  def index
    if params[:subcategory_id]
      @tags = Subcategory.find(params[:subcategory_id]).tags
      respond_to do |format|
        format.js { render :json => @tags.collect {|t| {:id => t.id, :name => t.name } }.to_json }
      end
    end
  end
  
  def show
    @tag = Tag.find(params[:id])
    @products = Product.tag_id_is(params[:id]).all.paginate(:page => params[:page], :per_page => 12)
    render 'stores/show', :layout => 'stores'
  end
  
end