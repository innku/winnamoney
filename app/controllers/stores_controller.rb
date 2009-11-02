class StoresController < ApplicationController
  
  before_filter   :cant_create_two_stores, :only => [:create]
  
  def index
    respond_to do |format|
      case params[:index_action]
        when "is_unique"
          store = Store.name_is(params[:q])
          format.js { render :json => store.to_json }
        else
          @stores = Store.all.paginate(:page => params[:page], :per_page => 20)
          format.html { }
      end
    end
  end
  
  def show
    @store = Store.find(params[:id])
  end
  
  def new
    @store = Store.find_by_id(session[:store_id]) || Store.new(:sponsor_id => nil)
  end
  
  def create
    @store = Store.new(params[:store])
    if @store.save
      session[:store_id] = @store.id
      flash[:notice] = "La tienda se cre&oacute; con &eacute;xito"
      session[:store_id] = @store.id
      redirect_to new_user_path()
    else
      render :action => 'new'
    end
  end
  
  def edit
    @store = Store.find(params[:id])
  end
  
  def update
    @store = Store.find(params[:id])
    if @store.update_attributes(params[:store])
      flash[:notice] = "La tienda se modific&oacute; con &eacute;xito."
      redirect_to new_user_path()
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @store = Store.find(params[:id])
    @store.destroy
    flash[:notice] = "La tienda se borr&oacute; con &eacute;xito."
    redirect_to stores_url
  end
  
  private
  
  def cant_create_two_stores
    if session[:store_id]
      redirect_to new_user_path
      return false
    end
  end
  
end
