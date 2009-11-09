class StoresController < ApplicationController
  
  before_filter      :find_store, :only => [:index, :new, :show, :edit, :update]
  before_filter      :clear_register_session, :only => [:show]
  
  def index
    respond_to do |format|
      case params[:index_action]
        when "is_unique"
          store = Store.name_is(params[:q])
          format.js { render :json => store.to_json }
        when "redirect_to_store"
          store = Store.with_subdomain(current_subdomain)
          if store
            if store.active? or (@current_user and @current_user.store == store)
              flash[:error] = "The store you were looking for is not active yet" if params[:not_found]
              format.html { redirect_to store }
            else
              format.html{ redirect_to "http://#{APP_CONFIG[:domain]}?not_found=true" }
            end
          else
            flash[:error] = "The store you're looking for doesn't exist"
            format.html { redirect_to new_session_path }
          end
        when "referrals"
          @stores = @current_store.referrals.paginate(:page => params[:page], :per_page => 20)
          format.html { render :layout => 'application'}
        when "downline"
          @levels = 3
          @store = Store.find_by_id(params[:id]) || @current_store
          @stores = @store.downline(:levels => @levels)
          format.html {render :action => 'downline', :layout => 'application'}
        else
          @stores = Store.all.paginate(:page => params[:page], :per_page => 20)
          format.html { }
      end
    end
  end
  
  def show
    products = params[:q].nil? ? Product.featured : Product.like(params[:q])
    @products = products.paginate(:page => params[:page], :per_page => 12)
    if @current_user and @current_store.inactive?
      render :action => 'pending', :layout => 'application'
    else
      render
    end
  end
  
  def new
    @store = Store.new()
    @store.sponsor_id = @current_store.id if @current_store
    @store.parent_id = params[:parent_id]
    @store.side = params[:side]
    render :layout => 'application'
  end
  
  def create
    @store = Store.new(params[:store])
    if @store.save
      session[:store_id] = @store.id
      flash[:notice] = "The store was created"
      session[:store_id] = @store.id
      redirect_to new_user_path()
    else
      render :action => 'new', :layout => 'application'
    end
  end
  
  def edit
    @store = @current_user.is_admin? ? Store.find(params[:id]) : @current_store
    render :layout => 'application'
  end
  
  def update
    @store = @current_user.is_admin? ? Store.find(params[:id]) : @current_store
    if @store.update_attributes(params[:store])
      flash[:notice] = "The store was updated"
      unless @current_user
        redirect_to new_user_path()
      else
        redirect_to @store.user
      end
    else
      render :action => 'edit', :layout => 'application'
    end
  end
  
  def destroy
    @store = Store.find(params[:id])
    @store.destroy
    flash[:notice] = "The store was deleted"
    redirect_to stores_url
  end
  
end
